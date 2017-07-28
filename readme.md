# SparseMatrixCSC -> (Crout) ILU

ILUC loops as follows:

```
for k = 1 : n
  row = zeros(n); row[k:n] = A[k,k:n]
  col = zeros(n); col[k+1:n] = A[k+1:n,k]

  for i = 1 : k - 1 && L[k,i] != 0
    row -= L[k,i] * U[i,k:n]
  end

  for i = 1 : k - 1 && U[i,k] != 0
    col -= U[i,k] * L[k+1:n,i]
  end

  # drop stuff in row & col
  U[k,:] = row
  L[:,k] = col / U[k,k]
  L[k,k] = 1
end
```

```
          k
+---+---+---+---+---+---+---+---+
| \ |   | x | x | x | x | x | x |
+---+---+---+---+---+---+---+---+
|   | \ | x | x | x | x | x | x |
+---+---+---+---+---+---+---+---+
| x | x | . | . | . | . | . | . | k
+---+---+---+---+---+---+---+---+
| x | x | . | \ |   |   |   |   |
+---+---+---+---+---+---+---+---+
| x | x | . |   | \ |   |   |   |
+---+---+---+---+---+---+---+---+
| x | x | . |   |   | \ |   |   |
+---+---+---+---+---+---+---+---+
| x | x | . |   |   |   | \ |   |
+---+---+---+---+---+---+---+---+
| x | x | . |   |   |   |   | \ |
+---+---+---+---+---+---+---+---+

col and row are the .'s, updated by the x's.
```

Suppose U is stored row-wise and L column-wise. There are multiple issues at each step `k`:

1. Looping over the non-zero entries in the `k`th row of L and the `k`th column of U.
2. Updating `row` means having access to non-zeros of `U` at column-index `k` and larger at each row `< k`; updating `col` mean having access to non-zeros of `L` at row-index `k` and larger at each column `< k`.
3. Computing `col` and `row` should go (more or less) sparse, yet they are linear combination of sparse columns and rows with a different sparsity pattern. See Saad's Iterative Methods book.