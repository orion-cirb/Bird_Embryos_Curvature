/*
 * Description: Downscale first image in input directory
 * Author: Héloïse Monnet @ ORION-CIRB
 * Date: February 2025
 * Repository:
 * Dependencies: None
*/

// Hide on-screen updates for faster macro execution
setBatchMode(true);

// Prompt user to select directory containing input images
inputDir = getDirectory("Please select a directory containing images to downscale");

// Generate results directory with timestamp
resultDir = inputDir + "Downscaled" + File.separator();
if (!File.isDirectory(resultDir)) {
	File.makeDirectory(resultDir);
}

// Retrieve list of all files in input directory
inputFiles = getFileList(inputDir);

// Open first image
run("Bio-Formats Importer", "open=["+inputDir+inputFiles[0]+"] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");

// Downscale by a factor of 2
run("Scale...", "x=0.5 y=0.5 average create");

// Convert to 8-bits
run("Macro...", "code=v=v/65535*255 stack");
getDimensions(width, height, channels, slices, frames);
for (c = 1; c <= channels; c++) {
	Stack.setChannel(c);
	for (s = 1; s <= slices; s++) {
		Stack.setSlice(s);
		setMinAndMax(0, 255);
	}
}
run("8-bit");

// Save obtained image
save(resultDir + inputFiles[0]);

// Close all open windows
close("*");

// Print completion message
print("Downscaling done!");

// Restore batch mode to default
setBatchMode(false);
