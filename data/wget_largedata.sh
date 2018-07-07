while read p || [[ -n $p ]]; do
  set -- $p
  mkdir $1
  cd $1

  # Get the data from UCI repo
  wget -r -nH -nd -np -R index.html* $2/;

  # Extract the data 
  tar xvzf *.tar.gz
  tar xvzf *.zip

  # Delete the compressed files
  rm *.tar.gz
  rm *.zip

  # Handle buzz separately
  if [ "$1" =  "buzz" ] ; then
  	mv regression/Twitter/Twitter.data .
  	rm -rf regression
  fi

  # copy the scripts to preprocess them over

  cp ../largedata/$1/*.m .
  cd ..

done <largedata_links.txt
