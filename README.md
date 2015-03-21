arduino
=======
####Checking out the examples and libraries

In order to download the examples, you first need to ensure that you have [Git](http://git-scm.com/) installed.

Start out by cloning this repository:

    git clone https://github.com/pixelstereo/arduino.git
    
Next you need to retrieve all submodules:

    cd  arduino
    git submodule update --init
    git checkout master
    git pull
    git submodule update
    git submodule foreach git checkout master
