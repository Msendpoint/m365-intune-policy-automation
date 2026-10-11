<#
.SYNOPSIS
    M365 & Intune Policy Automation for Junior Sysadmins

.DESCRIPTION
    A GitHub repository demonstrating how to automate Intune policy assignments to dynamic Entra ID groups, integrated with an M365 SaaS engine.

.NOTES
    Author:      Souhaiel Morhag
    Company:     MSEndpoint.com
    Blog:        https://msendpoint.com
    Academy:     https://app.msendpoint.com/academy
    LinkedIn:    https://linkedin.com/in/souhaiel-morhag
    GitHub:      https://github.com/Msendpoint
    Created:     2026-10-11
    License:     MIT

.EXAMPLE
    .\script.ps1
#>

### FILE: index.php
<?php

// This file serves as the main dashboard for the M365 SaaS engine.
// It orchestrates calls to Microsoft Graph via the provided $ms object and renders UI cards.

// Ensure the user is authenticated and has an access token.
if (!isset($_SESSION['ms_access_token'])) {
    // Redirect to login or show an error
    die('Authentication required. Please log in.');
}

$accessToken = $_SESSION['ms_access_token'];

// --- Example 1: Fetching Intune Device Compliance Policies ---
$policyEndpoint = '/deviceManagement/deviceCompliancePolicies';
$policiesData = $ms->graphCall($policyEndpoint, $accessToken);

if (isset($policiesData['value']) && is_array($policiesData['value'])) {
    $activePolicies = count($policiesData['value']);
    render_premium_card(
        'Active Intune Policies',
        (string)$activePolicies,
        null, // No trend value for this example
        'up', // Assume 'up' is good for policy count
        '🛡️'
    );
} else {
    render_premium_card('Active Intune Policies', 'N/A', null, 'down', '⚠️');
    error_log('Failed to fetch Intune policies: ' . json_encode($policiesData));
}

// --- Example 2: Fetching Dynamic Device Groups ---
$groupEndpoint = '/groups?$filter=groupTypes/any(c:c eq \'DynamicMembership\')';
$groupsData = $ms->graphCall($groupEndpoint, $accessToken);

if (isset($groupsData['value']) && is_array($groupsData['value'])) {
    $dynamicGroups = count($groupsData['value']);
    render_premium_card(
        'Dynamic Device Groups',
        (string)$dynamicGroups,
        null,
        'up',
        '👥'
    );
} else {
    render_premium_card('Dynamic Device Groups', 'N/A', null, 'down', '⚠️');
    error_log('Failed to fetch dynamic groups: ' . json_encode($groupsData));
}

// --- Example 3: Displaying Recent Sign-in Failures (Placeholder) ---
// In a real scenario, you would query Entra ID sign-in logs via Graph.
// For demonstration, let's simulate some data or fetch a simplified view.
// $signInLogsEndpoint = '/auditLogs/signIns?$filter=status/errorCode ne 0&$top=5';
// $failedSignIns = $ms->graphCall($signInLogsEndpoint, $accessToken);

// For this example, let's use a static card.
render_premium_card(
    'Recent Sign-in Failures',
    '5',
    '20% increase',
    'down',
    '❌'
);

// --- Integration with PowerShell Automation (Conceptual) ---
// If a user clicks a button to 'Assign Policy', the PHP backend would:
// 1. Validate input.
// 2. Potentially call the PowerShell script (e.g., via a system call or Azure Function).
// 3. Or, directly make the Graph API call for assignment using $ms->graphCall and a POST method.
//    Example: $ms->graphCall("/deviceManagement/deviceCompliancePolicies/{policyId}/assignments", $accessToken, 'POST', $assignmentBody);

// The PowerShell script 'Assign-IntunePolicyToDynamicGroup.ps1' would represent a backend automation
// that could be triggered by such a PHP interface or run on a schedule.

?>