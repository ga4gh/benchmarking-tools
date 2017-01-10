from __future__ import division

'Create a SAM/BAM file to represent genomic duplications'

import sys
import string
import argparse

from itertools import izip

import pysam

from locus_lib.bio.structs.recordtype import recordtype
from locus_lib.bio.core.smartfile     import smartfile
from locus_lib.bio.align.pysam_utils  import open_samfile
from locus_lib.bio.align.cigar_utils  import CigarSequence, INSERTION, DELETION


def ident(x):
    return x


ChainHeader = recordtype('ChainHeader', 'score tName tSize tStrand tStart tEnd qName qSize qStrand qStart qEnd id cigar')
ChainHeaderTypes = [int, intern, int, intern, int, int, intern, int, intern, int, int, str, ident]


complement_trans = string.maketrans('atcgnATCGN', 'tagcnTAGCN')


def c(sequence):
    return sequence.translate(complement_trans)


def rc(sequence):
    return sequence.translate(complement_trans)[::-1]


def load_chain(filename):
    dups = smartfile(filename)

    dup = None
    cigar = None

    for line in dups:
        row = line.rstrip().split()

        if not row or line[0] == '#':
            continue

        elif row[0] == 'chain':
            if dup:
                values = [adapter(value) for adapter, value in izip(ChainHeaderTypes, dup)]
                dup = ChainHeader(*values)
                yield dup

            cigar = CigarSequence()
            dup = row[1:] + [cigar]

        else:
            if len(row) == 1:
                row = row + [0, 0]

            size, dt, dq = map(int, row)

            if size:
                cigar.append(('M', size))
            if dt:
                cigar.append(('D', dt))
            if dq:
                cigar.append(('I', dq))

    if dup:
        values = [adapter(value) for adapter, value in izip(ChainHeaderTypes, dup)]
        dup = ChainHeader(*values)
        yield dup


def fix_chain(dups):
    for dup in dups:
        if dup.tStrand == '-':
            dup.tStart, dup.tEnd = dup.tSize - dup.tEnd, dup.tSize - dup.tStart
        if dup.qStrand == '-':
            dup.qStart, dup.qEnd = dup.qSize - dup.qEnd, dup.qSize - dup.qStart

        yield dup


def dup_to_align(out, ref, dup, min_ident=0.80, split=400):
    print >> sys.stderr, dup[:-1]

    if (dup.tName, dup.tStart) > (dup.qName, dup.qStart):
        print >> sys.stderr, '  Skipping (hopefully) redundant alignment pair'
        return

    r = ref.fetch(dup.tName, dup.tStart, dup.tEnd).upper()
    q = ref.fetch(dup.qName, dup.qStart, dup.qEnd).upper()

    assert len(r) == dup.tEnd - dup.tStart
    assert len(q) == dup.qEnd - dup.qStart

    if dup.tStrand == '-' and dup.qStrand == '-':
        q = q[::-1]
    elif dup.qStrand == '-':
        q = rc(q)

    print >> sys.stderr,'q=[%d-%d), r=[%d-%d)' % (dup.qStart,dup.qEnd,dup.tStart,dup.tEnd)
    for i,(ref_start, ref_stop, query_start, query_stop, cigar) in enumerate(split_alignment(dup.cigar,split),1):
        ref_len   = cigar.ref_len()
        query_len = cigar.query_len()

        assert ref_len   == ref_stop   - ref_start
        assert query_len == query_stop - query_start

        ref_part   = r[ref_start:ref_stop]
        query_part = q[query_start:query_stop]

        dup_part = ChainHeader(*dup)

        dup_part.tStart += ref_start
        dup_part.tEnd    = dup_part.tStart + ref_len
        dup_part.cigar   = cigar

        if dup.qStrand == '+':
            dup_part.qStart += query_start
            dup_part.qEnd    = dup_part.qStart + query_len
        else:
            dup_part.qStart = dup_part.qEnd - query_stop
            dup_part.qEnd   = dup_part.qStart + query_len

        print >> sys.stderr, '   Part %3d: r=[%d-%d), q=[%d-%d)' % (i,dup_part.qStart,dup_part.qEnd,dup_part.tStart,dup_part.tEnd)

        assert dup_part.tStart >= 0
        assert dup_part.qStart >= 0

        write_align_pair(out, dup_part, ref_part, query_part)

    print >> sys.stderr


def split_alignment(cigar, dist=400):
    ref_start   = ref_stop   = 0
    query_start = query_stop = 0
    cigar_part  = CigarSequence()

    for op, n in cigar:
        if op in (INSERTION,DELETION) and n > dist:
            if cigar_part:
                yield ref_start, ref_stop, query_start, query_stop, cigar_part
                cigar_part = CigarSequence()

            if op.consumes_ref_bases:
                ref_stop   += n
            if op.consumes_read_bases:
                query_stop += n
            ref_start       = ref_stop
            query_start     = query_stop
        else:
            if op.consumes_ref_bases:
                ref_stop   += n
            if op.consumes_read_bases:
                query_stop += n
            cigar_part.append( (op,n) )

    if cigar_part:
        yield ref_start, ref_stop, query_start, query_stop, cigar_part



def write_align_pair(out, dup, r, q):
    qname = '%s:%d-%d(%s)_%s:%d-%d(%s)' % (dup.tName, dup.tStart + 1, dup.tEnd, dup.tStrand,
                                           dup.qName, dup.qStart + 1, dup.qEnd, dup.qStrand)

    tid1 = out.gettid(dup.tName)
    tid2 = out.gettid(dup.qName)

    assert tid1 != -1 and tid2 != -1

    if tid1 != -1:
        a = pysam.AlignedRead()
        a.qname = qname
        a.tid   = tid1
        a.pos   = dup.tStart
        a.mapq  = 255
        a.seq   = q
        a.cigar = dup.cigar.to_pysam_list()
        a.tags  = [('RG','hg38.chain')] #[,('NM', nm)]
        a.tlen  = 0
        a.flag  = 0
        a.rnext = tid2

        if dup.tStrand == '-':
            a.flag |= 0x10

        if tid2 != -1:
            a.rnext = tid2
            a.pnext = dup.qStart
            a.flag = 0x1 | 0x2 | 0x40
            if dup.qStrand == '-':
                a.flag |= 0x20

        out.write(a)

    if tid2 != -1:
        cigar2 = dup.cigar
        if dup.qStrand != '+':
            cigar2.reverse()
        cigar2 = cigar2.invert()[0]

        b = pysam.AlignedRead()
        b.qname = qname
        b.tid   = tid2
        b.pos   = dup.qStart
        b.mapq  = 255
        b.seq   = r if dup.qStrand == '+' else rc(r)
        b.cigar = cigar2.to_pysam_list()
        b.tags  = [('RG','hg38.chain')] # ,('NM', nm)]
        b.tlen  = 0
        b.flag  = 0
        b.rnext = tid1

        if dup.qStrand == '-':
            b.flag |= 0x10

        if tid1 != -1:
            b.rnext = tid1
            b.pnext = dup.tStart
            b.flag |= 0x1 | 0x2 | 0x80
            if dup.tStrand == '-':
                b.flag |= 0x20

        out.write(b)


def option_parser():
    parser = argparse.ArgumentParser(description=__doc__)

    parser.add_argument('dups', help='UCSC self-chain file')

    parser.add_argument('--reference', '-r', metavar='NAME',
                        help='Reference genome sequence (FASTA + FAI files)')
    parser.add_argument('--output', '-o' , metavar='FILE', default='-',
                        help='Output SAM/BAM file')
    parser.add_argument('--minident', metavar='N', type=float, default=0.90,
                        help='Minimum identity (default=0.90)')
    parser.add_argument('--split', metavar='N', type=int, default=400,
                        help='Split alignments with gaps larger than N (default=400)')
    return parser


def main():
    parser = option_parser()
    options = parser.parse_args()

    ref = pysam.Fastafile(options.reference)

    header = {'HD': {'VN': '1.0', 'SO': 'queryname'},
              'RG': [{'ID': 'hg38.chain', 'DS': 'UCSC hg38 self-chain alignments', 'SM': 'in silico sample'}]}

    header['SQ'] = sqlist = []

    for name,length in izip(ref.references,ref.lengths):
        if '_' in name:
            continue
        sqlist.append({'SN': name, 'LN': length, 'AS': 'GRCh38', 'SP': 'Homo sapiens'})

    dups = fix_chain(load_chain(options.dups))

    with open_samfile(options.output, 'w', header=header) as out:
        for dup in dups:
            dup_to_align(out, ref, dup, options.minident, options.split)


if __name__ == '__main__':
    main()
