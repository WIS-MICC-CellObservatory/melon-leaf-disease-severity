# Melon leaf disease severity image analysis

Companion to *Swarming bacteria drive opposing ecological outcomes in plant-pathogen interactions* by Adi Glass Livneh and colleagues. This workflow quantifies the percentage of symptomatic tissue per melon leaf at six days post-inoculation for Figure 1.

## Study highlights

- *Paenibacillus glucanolyticus* promoted the spread of *Paracidovorax citrulli* on agar and melon leaves and increased disease severity. The non-motile `motB` mutant showed neither effect.
- *Paenibacillus dendritiformis* showed antibacterial activity against *P. citrulli* and reduced disease severity in melon plants.


## Repository layout

| Path | Contents |
| --- | --- |
| `macros/total_leaf_area.ijm` | Fiji macro that thresholds the segmentation, fills holes, and adds candidate whole-leaf ROIs to the ROI Manager. |
| `macros/disease_leaf_area.ijm` | Fiji macro that measures connected regions selected by the original disease threshold. |
| `macros/disease_in_roi.ijm` | Original Fiji macro used to summarize thresholded regions within saved whole-leaf ROIs and export a CSV. The source file is named `disease_in_ROI.ijm`. |
| `models/melon_leaf_pixel_classifier.ilp` | Trained ilastik Pixel Classification project to add. |
| `sample-data/input/IMG_20220727_104114.jpg` | Photograph of the six sample leaves. |
| `sample-data/segmentation/IMG_20220727_104114_segmentation.tif` | Matching ilastik label image used as Fiji input. |
| `sample-data/rois/IMG_20220727_104114_rois.zip` | Six whole-leaf Fiji ROIs generated from the sample segmentation. |
| `sample-data/qc/IMG_20220727_104114_label_check.csv` | Per-leaf counts and percentages for labels 2 and 3. Rows run left to right across the top row, then the bottom row. |
| `sample-data/expected/IMG_20220727_104114_disease_severity.csv` | Reference CSV to add after confirming the disease label for this export and reproducing the six measurements in Fiji. |

## Workflow

### Segment a leaf image with ilastik

Open the trained `.ilp` project in [ilastik](https://www.ilastik.org/) and apply it to the leaf image using **Batch Processing**. The classifier was trained with manual pixel annotations for background, healthy tissue, and symptomatic tissue. Export **Simple Segmentation** as TIFF. For the six-leaf example, start with the supplied segmentation TIFF. [ilastik Pixel Classification guide](https://www.ilastik.org/documentation/pixelclassification/pixelclassification)

### Load or create the six leaf ROIs

Open the segmentation TIFF in [Fiji](https://fiji.sc/) and load the sample ROI ZIP through **ROI Manager → More → Open**. Use **Show All** to check the outlines against the segmentation. To regenerate them, run `total_leaf_area.ijm` on a duplicate of the TIFF with an empty ROI Manager. Correct outlines if needed, select all six whole-leaf ROIs, and save them through **More → Save**.

### Confirm the disease label and measure its area

The recovered disease macros use a threshold of 109–154 after contrast normalization, which selects label 2 in this sample TIFF. The training protocol screenshot lists Disease as the third class, which suggests label 3. The visibly damaged top-left leaf contains 2.589% label 2 and 96.825% label 3. Confirm the label from the exact ilastik project used for the export and inspect the label overlay against the photograph. Use the label-check CSV to compare the measured percentages.

1. Open the original segmentation TIFF and load the six whole-leaf ROIs.
2. In **Image → Adjust → Threshold**, use **Set** to enter the confirmed disease label as both threshold bounds. Leave the threshold active.
3. In **Analyze → Set Measurements**, enable **Area Fraction** and **Display Label**. Leave **Limit to Threshold** unchecked. Select the six whole-leaf ROIs and click **Measure** in the ROI Manager.
4. Save the **Results** table as CSV. Use `%Area` for the disease percentage and compare it to the corresponding label column in the label-check CSV. [ImageJ measurement guide](https://imagej.net/ij/docs/guide/user-guide.pdf)

**Disease severity (%) = 100 × symptomatic pixels within a leaf ROI / total pixels within that ROI.**

To run the original `disease_in_roi.ijm` on this sample, update the input, output, and ROI paths and the ROI ZIP name, set the suffix to `.tif`, and remove the trailing semicolon from the `endsWith` conditional. Verify that its threshold selects the confirmed disease class and compare the macro's output with the direct ROI measurement.
