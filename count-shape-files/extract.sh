for dirpath in $( find . -name '*.shp' );
do
    ogr2ogr -f "CSV" $(basename $dirpath)_output.csv $dirpath;
done
