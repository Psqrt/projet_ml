boxcox_transformation = function (x, lambda) {
    new_x = (x ** lambda - 1) / lambda
    return(new_x)
}