# screenshot.ps1
# Description: Captures the entire virtual screen (all monitors) and saves it to a public folder.

# Define the output path for the screenshot
$outputPath = "$env:temp\LuckyCapture"
while (Test-Path "${outputPath}${c}.jpg") {
            $c++
        }

# Load the required .NET assemblies for graphics and forms
# The Add-Type command might fail if already loaded, so we suppress errors.
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Error handling block
try {
    # Get the dimensions of the entire virtual screen (spans all monitors)
    $screenWidth = [System.Windows.Forms.SystemInformation]::VirtualScreen.Width
    $screenHeight = [System.Windows.Forms.SystemInformation]::VirtualScreen.Height
    $screenLeft = [System.Windows.Forms.SystemInformation]::VirtualScreen.Left
    $screenTop = [System.Windows.Forms.SystemInformation]::VirtualScreen.Top

    # Create a bitmap object with the screen's dimensions
    $bitmap = New-Object System.Drawing.Bitmap($screenWidth, $screenHeight)

    # Create a graphics object from the bitmap
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

    # Copy the screen into the graphics object
    $graphics.CopyFromScreen($screenLeft, $screenTop, 0, 0, $bitmap.Size)

    # Save the bitmap to the specified file path as a PNG
    $bitmap.Save("$outputPath${c}.jpg", [System.Drawing.Imaging.ImageFormat]::Png)

    # Clean up resources
    $graphics.Dispose()
    $bitmap.Dispose()
}
catch {
}