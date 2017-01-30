for dirpath in $( find . -name '*.csv' );
do
    wc -l $dirpath ;
    awk -F ',' '{print $3}' $dirpath  | sort | uniq | wc -l;
done
