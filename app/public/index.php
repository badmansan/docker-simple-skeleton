<?php

use Doctrine\Common\Collections\ArrayCollection;

require __DIR__ . '/../vendor/autoload.php';

// test autoload
$collection = new ArrayCollection(range(10, 20));
print_r($collection->toArray());

phpinfo();
