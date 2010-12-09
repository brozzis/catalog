
DATE=$(date +"%y%m%d")
perl readDocs.pl > cloud-$DATE.html
ln -sf cloud-$DATE.html cloud.html
