This CIS TOOLKIT is intended only for Standalone instances of Windows and not intended for computers joined to a domain.  The toolkit will work on both, but domain joined computers should be managed from Group Policy and not by locally applied policies. This tool will modify the registry of your system and should be run at the user’s own risk.  The Center for Internet Security assumes no responsibility for issues that this tool may cause.  Please make sure that the remediation kit you are applying contain the settings you would like to apply before applying any settings.  Please make a backup prior to making any changes.

this script uses Microsoft lgpo.exe tool- https://blogs.technet.microsoft.com/secguide/2016/01/21/lgpo-exe-local-group-policy-object-utility-v1-0/


To Apply custom built or modified Remediation outside of what's included (No Remediation files included on GITHUB, files will only be availible to CIS members) please place the following files:
comp_registry.pol
GptTmpl.inf
user_registry.pol

into the folder of the corresponding OS. **Example CIS-Toolkit\Scripts\Windows_10\Level_1
Please remove the current files contained within the folder and copy in the new modified/custom files



To run the Tool
Run CIS_ToolKit.cmd as an administrator

follow the onscreen instructions


Please provide any feedback to support@cisecurity.org so that we can work on improving this tool
