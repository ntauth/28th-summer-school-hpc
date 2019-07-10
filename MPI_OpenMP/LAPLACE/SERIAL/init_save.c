#include <stdlib.h>
#include <stdio.h>
#include <math.h>

double ind2pos(int i, int n, double L) {
    double ret_val;
    ret_val = ((i-1)-(n-1)/ 2.0)*L/(n-1);
    return ret_val;
}

int init_field(double *temp, int n, int L) {
    // initialize the T field
    int ix,iy;
    double x, y;
    const double sigma = 0.1;
    const double tmax = 100.;
    
    for(iy=0;iy<=n+1;++iy)
        for(ix=0;ix<=n+1;++ix){
            x=ind2pos(ix, n, L);
            y=ind2pos(iy, n, L);
            temp[((n+2)*iy)+ix] = tmax*exp((-((x*x)+(y*y)))/(2.0*(sigma*sigma)));
        }
    return 0;
}
