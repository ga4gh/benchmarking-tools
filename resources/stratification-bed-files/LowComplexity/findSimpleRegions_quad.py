#!/usr/bin/python

# The MIT License (MIT)
#
# Copyright (c) 2013 InVitae Corp, http://invitae.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

import sys
import argparse
from Bio import SeqIO

def parse_args():
    parser = argparse.ArgumentParser( description=__doc__ )

    parser.add_argument( '-p', '--min-homopolymer-length', help='Minimum length of a reportable homopolymer',
                         type=int, default=11)
    parser.add_argument( '-d', '--min-dinucleotide-length', help='Minimum length of a reportable dinucleotide',
                         type=int, default=20)
    parser.add_argument( '-t', '--min-trinucleotide-length', help='Minimum length of a reportable trinucleotide',
                         type=int, default=20)
    parser.add_argument( '-q', '--min-quadnucleotide-length', help='Minimum length of a reportable quadnucleotide',
                                             type=int, default=20)
    parser.add_argument( 'FASTA', help='FASTA file to examine, multiple entries supported')
    parser.add_argument( 'BED', help='Output BED file')
    args = parser.parse_args()

    return args

def run(args):
    fasta = open(args.FASTA, "rU")
    bedfile = open(args.BED, "w")

    print >>bedfile, "#input file: %s" % (args.FASTA)
    print >>bedfile, "#MIN_REPORTABLE_HOMOPOLYMER_LENGTH = " + str(args.min_homopolymer_length)
    print >>bedfile, "#MIN_REPORTABLE_DINUCLEOTIDE_LENGTH = " + str(args.min_dinucleotide_length)
    print >>bedfile, "#MIN_REPORTABLE_TRINUCLEOTIDE_LENGTH = " + str(args.min_trinucleotide_length)
    print >>bedfile, "#MIN_REPORTABLE_QUADNUCLEOTIDE_LENGTH = " + str(args.min_quadnucleotide_length)

    for record in SeqIO.parse(fasta, "fasta") :
        sequence = str(record.seq).upper()
        lastBase = "N"
        HPspanLength = 0
        HPstart = 0
        DNstart = 0
        TNstart = 0
        QNstart = 0
        inDinuc = False
        inTrinuc = False
        inQuadnuc = False
        for i, base in enumerate(sequence):
            if base != lastBase:
                if lastBase != "N" and HPspanLength >= args.min_homopolymer_length:
                    print >>bedfile, "\t".join([record.id,str(HPstart),str(i),"unit=" + lastBase])
                lastBase = base
                HPstart = i
                HPspanLength = 0
            else:
                HPspanLength += 1

            #dinucs
            if inDinuc:
                if sequence[i:i+2] != sequence[i+2:i+4]:
                    if sequence[i] != "N" and sequence[i+1] != "N" and (i+4 - DNstart) >= args.min_dinucleotide_length:
                        print >>bedfile, "\t".join([record.id,str(DNstart),str(i+3),"unit=" + sequence[DNstart:DNstart+2]])
                    inDinuc= False
            else:
                if sequence[i:i+2] == sequence[i+2:i+4] and sequence[i] != sequence[i+1]:
                    inDinuc = True
                    DNstart = i

            #trinucs
            if inTrinuc:
                if sequence[i:i+3] != sequence[i+3:i+6]:
                    if sequence[i:i+3].find("N") == -1 and (i+6 - TNstart) >= args.min_trinucleotide_length:
                        print >>bedfile, "\t".join([record.id,str(TNstart),str(i+5),"unit=" + sequence[TNstart:TNstart+3]])
                    inTrinuc= False
            else:
                if sequence[i:i+3] == sequence[i+3:i+6] and (sequence[i] != sequence[i+1] or sequence[i] != sequence[i+2] or
                                                             sequence[i+1] != sequence[i+2]):
                    inTrinuc = True
                    TNstart = i
        
            #quadnucs
            if inQuadnuc:
                if sequence[i:i+4] != sequence[i+4:i+8]:
                    if sequence[i:i+4].find("N") == -1 and (i+8 - QNstart) >= args.min_quadnucleotide_length:
                        print >>bedfile, "\t".join([record.id,str(QNstart),str(i+7),"unit=" + sequence[QNstart:QNstart+4]])
                    inQuadnuc= False
            else:
                if sequence[i:i+4] == sequence[i+4:i+8] and (sequence[i] != sequence[i+1] or sequence[i] != sequence[i+2] or sequence[i+1] != sequence[i+2] or sequence[i] != sequence[i+3] or sequence[i+1] != sequence[i+3] or sequence[i+2] != sequence[i+3]) and (sequence[i:i+2] != sequence[i+2:i+4]):
                    inQuadnuc = True
                    QNstart = i
 
    fasta.close()
    bedfile.close()

if __name__=='__main__':
    args = parse_args()
    sys.exit( run( args ) )
