run("glasbey");
run("Enhance Contrast...", "saturated=0.35 normalize");
setAutoThreshold("Default dark");
run("Threshold...");
setThreshold(109, 154);
run("Convert to Mask");


showMessage("if needed- manually seperate leaves");


run("Analyze Particles...", "size=0-Infinity clear summarize add");
run("Select All");
roiManager("Measure");
