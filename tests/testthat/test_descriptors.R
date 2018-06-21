library(testthat)
library(parsnip)

template <- function(col, pred, ob, lev, fact) 
  list(cols = col, preds = pred, obs = ob, levs = lev, facts = fact)

species_tab <- table(iris$Species, dnn = NULL)

###################################################################

context("Testing formula -> xy conversion")

test_that("numeric y and dummy vars", {
  expect_equal(
    template(4, 5, 150, NA, 1),
    parsnip:::get_descr_form(Sepal.Width ~ ., data = iris)
  )
  expect_equal(
    template(1, 2, 150, NA, 1),
    parsnip:::get_descr_form(Sepal.Width ~ Species, data = iris)
  )  
})

test_that("numeric y and x", {
  expect_equal(
    template(1, 1, 150, NA, 0),
    parsnip:::get_descr_form(Sepal.Width ~ Sepal.Length, data = iris)
  )
  expect_equal(
    template(1, 1, 150, NA, 0),
    parsnip:::get_descr_form(Sepal.Width ~ log(Sepal.Length), data = iris)
  )  
})

test_that("factor y", {
  expect_equal(
    template(4, 4, 150, species_tab, 0),
    parsnip:::get_descr_form(Species ~ ., data = iris)
  )
  expect_equal(
    template(1, 1, 150, species_tab, 0),
    parsnip:::get_descr_form(Species ~ Sepal.Length, data = iris)
  )  
})

test_that("factors all the way down", {
  expect_equal(
    template(3, 7, 24, table(npk$K, dnn = NULL), 3),
    parsnip:::get_descr_form(K ~ ., data = npk[,1:4])
  )
})

test_that("weird cases", {
  # So model.frame ignores - signs in a model formula so Species is not removed
  # prior to model.matrix; otherwise this should have n_cols = 3
  expect_equal(
    template(4, 3, 150, NA, 1),
    parsnip:::get_descr_form(Sepal.Width ~ . - Species, data = iris)
  )
  # Oy ve! Before going to model.matrix, model.frame produces a data frame
  # with one column and that column is a matrix (with the results from
  # `poly(Sepal.Length, 3)`
  expect_equal(
    template(1, 3, 150, NA, 0),
    parsnip:::get_descr_form(Sepal.Width ~ poly(Sepal.Length, 3), data = iris)
  )    
  expect_equal(
    template(0, 0, 150, NA, 0),
    parsnip:::get_descr_form(Sepal.Width ~ 1, data = iris)
  )     
})

###################################################################

context("Testing xy -> formula conversion")

test_that("numeric y and dummy vars", {
  expect_equal(
    template(4, 4, 150, species_tab, 0),
    parsnip:::get_descr_xy(x = iris[, 1:4], y = iris$Species)
  )
  expect_equal(
    template(2, 2, 150, NA, 1),
    parsnip:::get_descr_xy(x = iris[, 4:5], y = iris[, 1:2])
  )  
  expect_equal(
    template(2, 2, 150, NA, 1),
    parsnip:::get_descr_xy(x = iris[, 4:5], y = iris[, 1, drop = FALSE])
  )    
})





