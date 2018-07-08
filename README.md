# Coursera's Getting and Cleaning Data Project
Part of the Johns Hopkins Data Science Specialization

This is student-created work for the purposes of a graded project. Nothing in this repository implies the student's participation in the creation of the course or data itself.

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

For an explanation of the data and transformations involved in this project, see [CodeBook.md](https://github.com/vslearns/dsc3_gcdata/blob/master/CodeBook.R).

## Walkthrough
1. To run this project, source the file `run_analysis.R`.

```
source(paste(getwd(), "run_analysis.R", sep="/"))
```

2. This will call the `run_analysis()` function, which will first run environment checks.
3. The `check_data_dir()` function will check if the data directory exists. If not, it will download the data as necessary and unzip it.
4. The `load_libs()` function will install (if necessary) the `dplyr` and `reshape2` packages and load them into R.
5. The `load_data_get_ms()` function will use the `dd.open(filename)` function to read the six tables (feature data, activities, and subjects, for each of training and testing) into R by passing in each file's `filename`.
6. Using `dplyr`'s operation chaining, the datasets will have their columns named by the `feature_descript(dataset)`, `activity_descript(dataset)`, and `subject_descript(dataset)` functions.x
7. A `dirty_data` set will be created and will hold the result of the following code:

```
rbind(cbind(training_set, training_act, training_sub),
      cbind(testing_set, testing_act, testing_sub))
```

8. A `dirty_ms_data` set will be created and will hold the result of the following code:

```
select(dirty_data, matches("mean|std"), one_of("subject", "activity"))
```

9. The original `dirty_data` set will be deleted from memory.
10. The `tidy(dirty_dataset)` function will `melt` the `dirty_ms_data` set and then `dcast` it to create a `tidy_data` set. The `melted_data` set will then be destroyed along with the `dirty_data` set.
11. The `tidy_dataset` will be written to a TXT file to fulfill the project's requirements. It will also be written to a CSV file for convenience and pleasure.
12. The `run_analysis()` function will end after returning `tidy_data` to the environment.

## In this Repository
Consistent with the project requirements, the following files are included in this repository:
1. A tidy data set in TXT format: [tidy_data.txt](https://github.com/vslearns/dsc3_gcdata/blob/master/tidy_data.txt).
2. An R script called [`run_analysis.R`](https://github.com/vslearns/dsc3_gcdata/blob/master/run_analysis.R), which performs the analysis.
3. A [CodeBook.md](https://github.com/vslearns/dsc3_gcdata/blob/master/CodeBook.md) file that describes variables and the transformations made to tidy the data.

Additionally, a tidy set is included in CSV format: [tidy_data.csv](https://github.com/vslearns/dsc3_gcdata/blob/master/tidy_data.csv), along with this README to guide a user through the R script's process.