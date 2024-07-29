Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to create a new transaction based on a template and send it to a single recipient
function CreateAndSendTransaction {
    param (
        [string]$templateID,
        [string]$recipientEmail
    )

    # Define the OneSpan API endpoint and the API key (replace with your actual API key)
    $apiUrl = "https://api.onespan.com/api/packages"
    $apiKey = "YOUR_API_KEY"

    # Define the request body for creating a new transaction based on a template
    $requestBody = @{
        "templateId" = $templateID
        "recipients" = @(
            @{
                "email" = $recipientEmail
                "role" = "SIGNER"
            }
        )
    } | ConvertTo-Json -Depth 3

    # Make the API call to create a new transaction
    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers @{ "Authorization" = "Bearer $apiKey"; "Content-Type" = "application/json" } -Body $requestBody

        # Display the transaction ID
        [System.Windows.Forms.MessageBox]::Show("Transaction Created Successfully. Transaction ID: $($response.id)")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error: $_")
    }
}

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Create And Send OneSpan Transaction"
$form.Size = New-Object System.Drawing.Size(400, 200)

# Create the template ID label and textbox
$templateIDLabel = New-Object System.Windows.Forms.Label
$templateIDLabel.Text = "Template ID:"
$templateIDLabel.Location = New-Object System.Drawing.Point(10, 20)
$form.Controls.Add($templateIDLabel)

$templateIDTextbox = New-Object System.Windows.Forms.TextBox
$templateIDTextbox.Location = New-Object System.Drawing.Point(100, 20)
$templateIDTextbox.Size = New-Object System.Drawing.Size(250, 20)
$form.Controls.Add($templateIDTextbox)

# Create the recipient email label and textbox
$recipientEmailLabel = New-Object System.Windows.Forms.Label
$recipientEmailLabel.Text = "Recipient Email:"
$recipientEmailLabel.Location = New-Object System.Drawing.Point(10, 60)
$form.Controls.Add($recipientEmailLabel)

$recipientEmailTextbox = New-Object System.Windows.Forms.TextBox
$recipientEmailTextbox.Location = New-Object System.Drawing.Point(100, 60)
$recipientEmailTextbox.Size = New-Object System.Drawing.Size(250, 20)
$form.Controls.Add($recipientEmailTextbox)

# Create the submit button
$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Text = "Create And Send"
$submitButton.Location = New-Object System.Drawing.Point(10, 100)
$submitButton.Size = New-Object System.Drawing.Size(150, 30)
$submitButton.Add_Click({
    $templateID = $templateIDTextbox.Text
    $recipientEmail = $recipientEmailTextbox.Text
    CreateAndSendTransaction -templateID $templateID -recipientEmail $recipientEmail
})
$form.Controls.Add($submitButton)

# Show the form
[void]$form.ShowDialog()
