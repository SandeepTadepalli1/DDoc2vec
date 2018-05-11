# @Author: sandeep
# @Date:   2018-05-12 00:34:34
# @Last Modified by:   sandeep
# @Last Modified time: 2018-05-12 00:40:34
#!/bin/bash
echo "*** Removing Punctuation marks ***"
sed -e $'s/\t//g' -e "s/[[:punct:]]\+//g" -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' data/test/neg/* > test_neg.txt
sed -e $'s/\t//g' -e "s/[[:punct:]]\+//g" -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' data/test/pos/* > test_pos.txt
sed -e $'s/\t//g' -e "s/[[:punct:]]\+//g" -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' data/train/neg/* > train_neg.txt
sed -e $'s/\t//g' -e "s/[[:punct:]]\+//g" -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' data/train/pos/* > train_pos.txt
sed -e $'s/\t//g' -e "s/[[:punct:]]\+//g" -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' data/train/unsup/* > train_unsup.txt

echo "*** Done ***"
echo "*** Labeling each document ***"
nl -nrz -w9 train_neg.txt > test1.txt
awk '$0="TRAIN_NEG"$0' test1.txt >train_neg_labeld.txt

nl -nrz -w9 train_pos.txt > test1.txt
awk '$0="TRAIN_POS"$0' test1.txt >train_pos_labeld.txt

nl -nrz -w9 train_unsup.txt > test1.txt
awk '$0="TRAIN_USP"$0' test1.txt >train_unsup_labeld.txt

nl -nrz -w9 test_neg.txt > test1.txt
awk '$0="TEST__NEG"$0' test1.txt >train_neg_labeld.txt

nl -nrz -w9 test_pos.txt > test1.txt
awk '$0="TEST__POS"$0' test1.txt >train_pos_labeld.txt
echo "***Done***"

echo "***Collecting the labeled documents"
cat *labeld.txt > tagged_docs.txt
echo "***Done***"
echo "***Shuffling the data***"
shuf tagged_docs.txt > tagged_docs_shuffled.txt
echo "***Done***"

echo "***Removing temp files ***"
rm train_neg.txt
rm train_unsup.txt
rm train_pos.txt
rm test_neg.txt
rm test_pos.txt
rm train_pos_labeld.txt
rm train_neg_labeld.txt
rm train_unsup_labeld.txt
rm test1.txt
rm tagged_docs.txt
echo "***Done***"