## Image compression server

#* Image compression
#*
#* @post /compress
#* @serializer rds
#* @parser rds
#*
function(body) {
    message("compressing image data")
    imgdata <- body$imgdata
    compress <- body$compress
    s <- svd(imgdata)
    nc <- ncol(s$u)
    nkeep <- floor(exp(-compress / 15) * nc) + 2
    message("  nkeep: ", nkeep)
    keep <- seq_len(nkeep)
    ustar <- s$u[, keep]
    vstar <- s$v[, keep]
    dstar <- s$d[keep]
    rstar <- ustar %*% diag(dstar) %*% t(vstar)
    rstar <- (rstar - min(rstar)) / max(rstar - min(rstar))
    rstar
}

