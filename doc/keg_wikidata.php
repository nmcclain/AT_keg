<?php
// this script cleans up the wiki page data so it's ready for the ipad to use

// fetch the kegorator wiki page
$url = "http://localhost/wiki_myatekegerator.html";
$content = `wget -q -O - $url`;

// find the table of keg data
if (!preg_match("/Currently on Tap(.*)Please edit this table carefully/msU", $content, $matches)) {
   echo "Keg 1,Keg 2,,\n";
   exit(0);
} 
$table = preg_replace('/,/', ' ', $matches[1]);

// find the keg names
if (!preg_match("/<tr ><td  align='center'>Name<\/td><td  align='center'>(.*)<\/td><td  align='center'>(.*)<\/td><\/tr>/", $table, $matches)) {
   echo "Keg 1,Keg 2,,\n";
   exit(0);
} 
$k1name=$matches[1];
$k2name=$matches[2];

// find the keg descriptions
if (!preg_match("/<tr ><td  align='center'>Description<\/td><td  align='center'>(.*)<\/td><td  align='center'>(.*)<\/td><\/tr>/", $table, $matches)) {
   echo "Keg 1,Keg 2,,\n";
   exit(0);
} 
$k1desc=$matches[1];
$k2desc=$matches[2];

//success!
echo "$k1name,$k2name,$k1desc,$k2desc\n";

exit(0);
