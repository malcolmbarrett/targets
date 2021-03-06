tar_test("tar_renv() works", {
  expect_false(file.exists("_packages.R"))
  tar_script({
    tar_option_set(packages = c("tibble", "qs"))
    list()
  })
  tar_renv()
  pkgs <- sort(c("tibble", "qs", eval(formals(tar_renv)$extras)))
  expect_true(file.exists("_packages.R"))
  expect_equal(
    sort(readLines("_packages.R")),
    sort(
      c(
        "# Generated by targets::tar_renv(): do not edit by hand",
        paste0("library(", pkgs, ")")
      )
    )
  )
  expect_equal(
    readLines("_packages.R")[1],
    "# Generated by targets::tar_renv(): do not edit by hand"
  )
})

tar_test("tar_renv() works with custom path", {
  path <- tempfile()
  expect_false(file.exists(path))
  tar_script({
    tar_option_set(packages = c("tibble", "qs"))
    list()
  })
  tar_renv(path = path, callr_function = NULL)
  pkgs <- sort(c("tibble", "qs", eval(formals(tar_renv)$extras)))
  expect_true(file.exists(path))
  expect_equal(
    sort(readLines(path)),
    sort(
      c(
        "# Generated by targets::tar_renv(): do not edit by hand",
        paste0("library(", pkgs, ")")
      )
    )
  )
})

tar_test("tar_renv() packages set in tar_target()", {
  tar_script({
    tar_option_set(packages = character())
    list(
      tar_target(x, "foo", packages = "tibble")
    )
  })
  tar_renv(callr_function = NULL)
  pkgs <- sort(c("tibble", eval(formals(tar_renv)$extras)))
  expect_true(file.exists("_packages.R"))
  expect_equal(
    sort(readLines("_packages.R")),
    sort(
      c(
        "# Generated by targets::tar_renv(): do not edit by hand",
        paste0("library(", pkgs, ")")
      )
    )
  )
})

tar_test("tar_renv() formats set in tar_target()", {
  tar_script({
    tar_option_set(packages = character())
    list(
      tar_target(x, "foo", format = "qs")
    )
  })
  tar_renv(callr_function = NULL)
  pkgs <- sort(c("qs", eval(formals(tar_renv)$extras)))
  expect_true(file.exists("_packages.R"))
  expect_equal(
    sort(readLines("_packages.R")),
    sort(
      c(
        "# Generated by targets::tar_renv(): do not edit by hand",
        paste0("library(", pkgs, ")")
      )
    )
  )
})

tar_test("tar_renv() formats set in pattern targets", {
  tar_script({
    tar_option_set(packages = character())
    list(
      tar_target(y, "foo", packages = character(0)),
      tar_target(x, y, format = "qs", pattern = map(y))
    )
  })
  tar_renv(callr_function = NULL)
  pkgs <- sort(c("qs", eval(formals(tar_renv)$extras)))
  expect_true(file.exists("_packages.R"))
  expect_equal(
    sort(readLines("_packages.R")),
    sort(
      c(
        "# Generated by targets::tar_renv(): do not edit by hand",
        paste0("library(", pkgs, ")")
      )
    )
  )
})

tar_test("tar_renv() packages set in tar_option_set()", {
  tar_script({
    tar_option_set(
      packages = "tibble",
      format = "qs"
    )
    list()
  })
  tar_renv(callr_function = NULL)
  pkgs <- sort(c("tibble", "qs", eval(formals(tar_renv)$extras)))
  expect_true(file.exists("_packages.R"))
  expect_equal(
    sort(readLines("_packages.R")),
    sort(
      c(
        "# Generated by targets::tar_renv(): do not edit by hand",
        paste0("library(", pkgs, ")")
      )
    )
  )
})

tar_test("tar_renv() non-default extra packages", {
  tar_script({
    tar_option_set(packages = character())
    list()
  })
  tar_renv(extras = "tibble", callr_function = NULL)
  pkgs <- "tibble"
  expect_true(file.exists("_packages.R"))
  expect_equal(
    sort(readLines("_packages.R")),
    sort(
      c(
        "# Generated by targets::tar_renv(): do not edit by hand",
        paste0("library(", pkgs, ")")
      )
    )
  )
})

tar_test("tar_env() cannot go inside _targets.R", {
  tar_script({
    tar_renv()
    list(tar_target(x, 1))
  })
  expect_error(
    tar_validate(callr_function = NULL),
    class = "condition_validate"
  )
})
