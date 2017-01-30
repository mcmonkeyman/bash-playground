for dirpath in $( find . \! -name '*.zip' \! -name '*.sh'); do $(rm $dirpath ); done
