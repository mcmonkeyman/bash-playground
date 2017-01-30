for dirpath in $( find . -name '*.zip' ); do 7za x -o$(dirname $dirpath) $dirpath ; done
