# Melon leaf disease severity image analysis

Companion to *Swarming bacteria drive opposing ecological outcomes in plant-pathogen interactions* by Adi Glass Livneh and colleagues. This workflow quantifies the percentage of symptomatic tissue per melon leaf at six days post-inoculation for Figure 1.

## Study highlights

- *Paenibacillus glucanolyticus* promoted the spread of *Paracidovorax citrulli* on agar and melon leaves and increased disease severity. The non-motile `motB` mutant showed neither effect.
- *Paenibacillus dendritiformis* showed antibacterial activity against *P. citrulli* and reduced disease severity in melon plants.

## Repository layout

| Path | File to include |
| --- | --- |
| `README.md` | This guide. |
| `macros/total_leaf_area.ijm` | `Recored for total leaf area.ijm.ijm` with a shortened filename and a single `.ijm` extension. |
| `macros/disease_leaf_area.ijm` | `Recored for disease leaf area.ijm` with a shortened filename. |
| `macros/disease_in_roi.ijm` | The separate **Disease in ROI** macro named in the analysis protocol. Add the exact version used for the study once recovered. |
| `models/melon_leaf_pixel_classifier.ilp` | The trained ilastik Pixel Classification project used in the study. |
| `sample-data/input/example_01.tif` | A representative cropped melon-leaf TIFF as supplied to ilastik, at the original analysis resolution. |
| `sample-data/segmentation/example_01_segmentation.tif` | The corresponding ilastik **Simple Segmentation** TIFF used as Fiji input. |
| `sample-data/rois/example_01_rois.zip` | The Fiji ROI Manager export with the verified outline of each leaf in that image. |
| `sample-data/expected/example_01_disease_severity.csv` | The corresponding reference per-leaf results with leaf IDs matching the ROI names and a disease percentage column. |

The two supplied macros are available for this layout. The trained project, matched example files, and separate ROI measurement macro still need to be added. The sample filenames above are suggested names. Keep the same sample ID across the paired files.

## Requirements

- [ilastik](https://www.ilastik.org/) for predicting the segmentation from a cropped leaf TIFF.
- [Fiji](https://fiji.sc/) for working with the segmentation, leaf ROIs, and measurements. If running prediction from Fiji, install and configure the ilastik Fiji plugin.

## Workflow

1. **Segment the image.** Open the trained `.ilp` project in ilastik and apply it to the cropped input TIFF through **Batch Processing**. The classifier was trained from manual pixel annotations for background, healthy tissue, and symptomatic tissue. Export **Simple Segmentation** as TIFF. To start at the Fiji step, open the supplied reference segmentation once it has been added. [ilastik Pixel Classification documentation](https://www.ilastik.org/documentation/pixelclassification/pixelclassification).
2. **Define the whole-leaf ROIs.** Start with an empty Fiji ROI Manager and run `total_leaf_area.ijm` on a duplicate of the segmentation. It applies contrast normalization and a fixed threshold, fills holes in the binary mask, and adds connected regions that pass its size filter to the ROI Manager. Check that each ROI covers one whole leaf, separate touching leaves or remove artifacts when needed, and save the corrected ROIs as a ZIP. Use the reference ROI ZIP to check this step once it has been added.
3. **Inspect the symptomatic mask.** Run `disease_leaf_area.ijm` on a fresh duplicate of the same segmentation with an empty ROI Manager. The macro uses contrast normalization and a fixed threshold to create a binary mask, then identifies and measures connected symptomatic regions. Check that the mask selects the symptomatic class in the reference image. Those region areas describe patches of symptoms.
4. **Calculate one percentage per leaf.** The study protocol uses **Disease in ROI** with the original segmentation and the saved whole-leaf ROI ZIP to obtain `%Area`. For a manual check, use the verified, unthresholded binary symptom mask from step 3 with symptomatic pixels nonzero and all other pixels zero. Clear the ROI Manager, open the whole-leaf ROI ZIP on the matching mask, enable **Area fraction** in **Analyze → Set Measurements**, and measure all whole-leaf ROIs. Save the results as CSV. [ImageJ measurement documentation](https://imagej.net/ij/docs/guide/user-guide.pdf).

**Disease severity (%) = 100 × symptomatic pixels within the leaf ROI / total pixels within the same ROI.**

The two supplied macros use fixed Fiji thresholds after contrast normalization (124–255 for total leaf area and 109–154 for symptomatic area). Check both masks against the reference segmentation with the original bit depth and analysis export settings. Confirm the Fiji and ilastik versions and segmentation export settings on the matched example before publishing. The separate ROI measurement macro and reference CSV are needed to verify that this workflow reproduces the study's reported per-leaf values.
