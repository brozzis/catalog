
mkdir MAX
mv *.JPG *.jpg MAX
for i in MAX/*.jpg MAX/*.JPG 
do 
	convert -size 800x800 $i -resize 800x800 -quality 90 `basename $i`  
done
