# AutoPeak

AutoPeak is a MATLAB-based tool designed for automated extraction of MS1 peak intensities from LC–MS datasets and a provided targeted peaklist. It also supports isotopologue extraction.

##  Versions

AutoPeak provides three modes of operation:

### **A. Unlabeled Mode**

* Extracts MS1 peak intensities only
* use "batch_run_auto.m"
* Suitable for standard metabolomics workflows without isotope tracing

### **B. ¹³C Labeling Mode**

* Extracts intensities for all ¹³C isotopologues
* use "batch_run_auto13C.m"
* Enables carbon tracing and isotopologue distribution analysis
* Natural isotope abundance correction included. 

### **C. ¹³C/¹⁵N Dual Labeling Mode**

* Extracts intensities for both 13C and 15N isotopologues
* use "batch_run_auto13C15N.m"
* suitable for 15N-contained tracers
* Dual-tracer Natural isotope abundance correction included. 

---

##  Input: Job Template

AutoPeak requires a job template file (`.xlsx`) with the following columns:
In addition, parameter settings are need.  There's a default saved in the source, can be modified.

| Column Name    | Description                                                                                   |
| -------------- | --------------------------------------------------------------------------------------------- |
| `folder`       | Directory containing mzXML files                                                              |
| `inclusion`    | File name patterns to include (use `;` as separator). By default, `.mzXML` should be included |
| `exclusion`    | File name patterns to exclude                                                                 |
| `output_fname` | Output file name for extracted results                                                        |
| `pklist`       | Peak list file containing target m/z, rt, formula, compound                                   |

* A single job file may contain **multiple tabs (worksheets)**
* Job files should be placed in one of the following folders:

  * `jobs` (unlabeled mode)
  * `jobs13C` (¹³C labeling mode)
  * `jobs13C15N` (¹³C/¹⁵N dual labeling mode)

##  Output
* An output folder with the **same name as the job file** will be created under the corresponding job directory

* If the job file contains multiple tabs:

  * Subfolders will be created using the **tab (worksheet) names**
  * Results from each tab will be saved in the corresponding subfolder

---
##  Usage

AutoPeak supports **two modes of operation**:

### **1. Direct Function Call (Custom Settings)**

Run AutoPeak by specifying a job file and optional settings:

```matlab
batch_run_auto(job, settings)
```

* `job`: path to the job template (`.xlsx`)
* `settings`: structure containing user-defined parameters

---

### **2. Interactive Mode **

Run AutoPeak without arguments:

```matlab
batch_run_auto
```

* Uses **default settings**
* A **UI folder selector** will pop up
* Select the directory containing your job file(s)
* AutoPeak will automatically detect and process the job file(s)

##  Contact

For questions, suggestions, or bug reports, please open an issue in the repository.

---

If you want, I can also add a short **“expected output format” section** (very useful for users) or a **quick troubleshooting guide**.
