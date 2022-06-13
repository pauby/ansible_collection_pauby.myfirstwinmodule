#!powershell

#AnsibleRequires -CSharpUtil Ansible.Basic

#region Ansible params
$spec = @{
    options             = @{
        name      = @{ type = "str" }
        state     = @{ type = "str"; choices = "absent", "present" }
    }

    supports_check_mode = $true
}

$module = [Ansible.Basic.AnsibleModule]::Create($args, $spec)
#endregion

#region setup
$name = $module.Params.name
$state = $module.Params.state

$rootPath = 'c:\psconfeu2022'
$filePath = Join-Path -Path $rootPath -ChildPath $name

if (Test-Path -Path $rootPath) {
    New-Item -Path $rootPath -ItemType Directory -Force | Out-Null
}
#endregion

# set default changed value
$module.Result.changed = $false

# if the path exists and the state shuld be absent, remove the file
if (Test-Path -Path $filePath) {
    if ($state -eq 'absent') {
        Remove-Item -Path $filePath -Force
        $module.result.changed = $true
    }
}
else {
    # if the file does not exist and it should be present, create it
    if ($state -eq 'present') {
        New-Item -Path $filePath -ItemType File -Force | Out-Null
        $module.result.changed = $true
    }
}

$module.ExitJson()