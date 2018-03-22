
for i in *.fq
do
	echo "Looping... i is set to $i"
	head -n 4 $i
	echo " "
done


for i in *.fq
do
	echo "Mapeo de $i en genome_reference por hisat2"
	hisat2 -x Genome_Reference/genome_reference -U $i -S $i.sam
	echo " "
done


for i in *.fq.sam
do
        echo "Conversión de $i a archivo bam"
        samtools view -bS $i > $i.bam
        echo " "
done


for i in *.fq.sam.bam
do
        echo "Generación de archivo bam con secuencias no mapeadas de $i"
        samtools view -f 4 $i > $i.unmapped.sam
done

## to get the output in bam use : samtools view -b -f 4 file.bam > unmapped.bam

for i in *.unmapped.sam
do
	echo "Generación de archivo fastq de las secuencias no mapeadas de $i"
	cat $i | grep -v ^@ | awk '{print "@"$1"\n"$10"\n+\n"$11}' > $i.fastq
done
