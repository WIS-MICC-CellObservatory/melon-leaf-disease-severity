run("glasbey");
run("Enhance Contrast...", "saturated=0.35 normalize");
setAutoThreshold("Default dark");
run("Threshold...");
setThreshold(124, 255);
run("Convert to Mask");


showMessage("if needed- manually seperate leaves");


run("Fill Holes");
run("Analyze Particles...", "size=100-Infinity clear summarize add");
run("Select All");
roiManager("Measure");
