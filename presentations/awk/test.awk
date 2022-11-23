BEGIN {
    FS=","
    OFS = ","
    id=0
    print "CREATE TABLE questions ("
    print "id INTEGER NOT NULL PRIMARY KEY,"
    print "storyLine VARCHAR(100) NOT NULL,"
    print "pathOne INTEGER NOT NULL,"
    print "pathTwo INTEGER NOT NULL,"
    print "pathOneText VARCHAR(100) NOT NULL,"
    print "pathTwoText VARCHAR(100) NOT NULL,"
    print "buffer BOOLEAN NOT NULL,"
    print "ending BOOLEAN NOT NULL"
    print ");"

    print "insert into questions (id, storyLine pathOne, pathTwo, pathOneText, pathTwoText, buffer, ending ) values"
}

$2 == $3 && $2 < 0 {
    print "(" id "," $0 ",true,true),";
    id++
    next
}

$2 == $3{
    print "(" id "," $0 ",true,false ),"
    id++
    next
}


{
    print "(" id "," $0 ",true,true),"
    id++
    next
}

END {
    print ";"
}
