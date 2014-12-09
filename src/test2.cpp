
int unreached2( int x )
{
    int y = x;
    return y+3;
}

int reached2( int i )
{
    int j = i;

    if( j == 2 )
        return j;
    
    return 3;
}

