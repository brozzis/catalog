
use File::stat; 
use Time::localtime; 

$file = '/etc/hosts'; 
$datetime_string = ctime(stat($file)->mtime); 

print "file $file was updated at $datetime_string \n",stat($file)->mtime; 

