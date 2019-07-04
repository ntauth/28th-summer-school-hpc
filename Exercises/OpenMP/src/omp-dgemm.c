/**
 * @author Ayoub Chouak (@ntauth)
 *
 */

#include <assert.h>
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#if defined(_OPENMP)
    #include <omp.h>
#endif

typedef struct _mat2d
{
    double** mat;
    int rows;
    int cols;
} mat2d, *pmat2d;


mat2d* create_mat2d(int rows, int cols);
void   free_mat2d(mat2d* mat);
void   randomize_mat2d(mat2d* mat);
void   print_mat2d(mat2d* mat);

void dgemm(mat2d* m1, mat2d* m2, mat2d** result);

int main()
{
    mat2d* m1, *m2, *result;
    double wtm_start, wtm_end;

//    time(&tm_now);
//    srand48(time(&tm_now));

    m1 = create_mat2d(1000, 1000);
    m2 = create_mat2d(1000, 1000);

    randomize_mat2d(m1);
    randomize_mat2d(m2);

//    print_mat2d(m1);
//    printf("\n");
//    print_mat2d(m2);
//    printf("\n");

    wtm_start = omp_get_wtime();
    dgemm(m1, m2, &result);
    wtm_end = omp_get_wtime();

//    print_mat2d(result);

    printf("DGEMM took %f milliseconds", wtm_end - wtm_start);

    return 0;
}

mat2d* create_mat2d(int rows, int cols)
{
    mat2d* mat;
    int i;

    mat = malloc(sizeof(mat2d));

    mat->rows = rows;
    mat->cols = cols;

    mat->mat = malloc(rows * sizeof(double));

    for (i = 0; i < rows; i++)
        mat->mat[i] = malloc(cols * sizeof(double));

    return mat;
}

void free_mat2d(mat2d* mat)
{
    free(mat->mat);
    memset(mat, 0, sizeof(mat2d));
}

void randomize_mat2d(mat2d* mat)
{
    int i, j;

    for (i = 0; i < mat->rows; i++)
        for (j = 0; j < mat->cols; j++)
            mat->mat[i][j] = drand48();
}

void print_mat2d(mat2d* mat)
{
    int i, j;

    for (i = 0; i < mat->rows; i++)
    {
        for (j = 0; j < mat->cols; j++)
            printf("%f ", mat->mat[i][j]);
        printf("\n");
    }
}

void dgemm(mat2d* m1, mat2d* m2, mat2d** result)
{
    int i, j, k;

    assert(m1->cols == m2->rows);

    *result = create_mat2d(m1->rows, m2->cols);

    #pragma omp parallel for private(j, k)
    for (i = 0; i < m1->rows; i++)
    {
        for (j = 0; j < m2->cols; j++)
        {
            (*result)->mat[i][j] = 0;

            for (k = 0; k < m1->cols; k++)
                (*result)->mat[i][j] += m1->mat[i][k] * m2->mat[k][j];
        }
    }
}