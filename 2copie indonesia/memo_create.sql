
CREATE TABLE `indonesia` (
  `id` int(11) NOT NULL auto_increment,
  `file` varchar(30) NOT NULL,
  `size` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `md5` varchar(100) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
