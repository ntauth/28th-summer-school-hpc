#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <mpi.h>

double ind2pos(int i, int n, double L) {
    double ret_val;
    ret_val = ((i-1)-(n-1)/ 2.0)*L/(n-1);
    return ret_val;
}

int init_field(double *temp, int n, int L, int ix_start, int iy_start, int ix_size, int iy_size) {
    // initialize the T field
    int ix,iy;
    double x, y;
    const double sigma = 0.1;
    const double tmax = 100.;
    
    for(iy=0;iy<=iy_size+1;++iy)
        for(ix=0;ix<=ix_size+1;++ix){
            x=ind2pos(ix+ix_start, n, L);
            y=ind2pos(iy+iy_start, n, L);
            temp[ix*(iy_size + 2)+iy] = tmax*exp((-((x*x)+(y*y)))/(2.0*(sigma*sigma)));
        }
    return 0;
}


