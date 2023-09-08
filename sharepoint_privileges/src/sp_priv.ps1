# 別モジュールで全サイトを取得できる
# Connect-SPOService -Url https://cocoto5510-admin.sharepoint.com

# .envファイルの読み込み
Get-Content .env | foreach {
    $name, $value = $_.split('=')
    if ([string]::IsNullOrWhiteSpace($name) || $name.Contains('#')) {
        continue
    }
    Set-Content env:\$name $value
}

function excuteQuery {
    # $args.GetType()
    $ctx = Get-PnPContext # Get the Context
    foreach ( $i in $args ) {
        $ctx.Load($i)
        $ctx.ExecuteQuery()
    }
}

Function get_files($folderUrl) {
    Try {

        # file関係の権限設定を取得
        $files = Get-PnPFolderItem -FolderSiteRelativeUrl $folderUrl -ItemType File

        foreach ($file in $files) {
            excuteQuery $file.ListItemAllFields
            $item = $file.ListItemAllFields
            # Write-Progress -Id 0 "Step $files"

            # 無駄なboolのログ出力を抑止するために $devnull の変数へ結果格納
                        $devnull = Get-PnPProperty -ClientObject $item -Property HasUniqueRoleAssignments

            # 親からの権限継承をしていないものだけ個別権限を出力
            if ($item.HasUniqueRoleAssignments) {
                excuteQuery $item.RoleAssignments $item.file

                foreach ($RoleAssignments in $item.RoleAssignments) {
                    excuteQuery $RoleAssignments.Member $RoleAssignments.RoleDefinitionBindings
                    # Write-Progress -Id 1 -ParentId 0 "Step $files - Substep $RoleAssignments"

                    foreach($RoleDefinition in $RoleAssignments.RoleDefinitionBindings) {
                        # Write-Progress -Id 2  -ParentId 1 "Step $files - Substep $RoleAssignments - iteration $RoleDefinitio"
                        if (!$RoleDefinition.Hidden) {
                            # Selct-object 新しいプロパティの取得
                            $ObjectType = @{N = "Object Type"; E = { $item.FileSystemObjectType } }
                            $path = @{N = "Path"; E = { $item.file.ServerRelativeUrl } }
                            $permission = @{N = "Permission"; E = { $_.Name } }
                            $role_upn = @{N = "Role UPN"; E = { $RoleAssignments.Member.LoginName } }
                            $role = @{N = "Role"; E = { $RoleAssignments.Member.Title } }
                            $type_sharepoint_group = @{N = "Type"; E = { "SharePoint Group" } } # sharepoint
                            $type_security_group = @{N = "Type"; E = { "Security Group" } } # sharepoint以外


                            switch ($RoleAssignments.Member.PrincipalType) {
                                SharePointGroup {
                                    # MS365グループを対象にした権限付与を想定
                                    $my_array += $RoleDefinition |
                                    Select-Object $ObjectType, $path, $permission, $type_sharepoint_group, $role_upn, $role |
                                    Export-CSV $OutFile -Append -Force -Encoding UTF8 -NoTypeInformation
                                }
                                default {
                                    # byNameでの権限付与を想定
                                    $RoleDefinition |
                                    Select-Object $ObjectType, $path, $permission, $type_security_group, $role_upn, $role |
                                    Export-CSV $OutFile -Append -Force -Encoding UTF8 -NoTypeInformation
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Catch {
        write-host -f Red "Error Generating file Permission Report!" $_.Exception.Message
    }
}

Function get_SubFolders($folderUrl) {
    Try {
        get_files($folderUrl)

        # folder関係の権限設定を取得（サブフォルダへの再帰処理も実施）
        $folders = Get-PnPFolderItem -FolderSiteRelativeUrl $folderUrl -ItemType Folder

        foreach ($folder in $folders) {

            # システムフォルダはスキップ
            if ($folder.Name -ne "Forms") {
                excuteQuery $folder.ListItemAllFields
                $item = $folder.ListItemAllFields

                # 無駄なboolのログ出力を抑止するために $devnull の変数へ結果格納
                $devnull = Get-PnPProperty -ClientObject $item -Property HasUniqueRoleAssignments

                # 親からの権限継承をしていないものだけ個別権限を出力
                if ($item.HasUniqueRoleAssignments) {
                    excuteQuery $item.RoleAssignments $item.Folder
                    foreach ($RoleAssignments in $item.RoleAssignments) {
                        excuteQuery $RoleAssignments.Member $RoleAssignments.RoleDefinitionBindings

                        foreach ($RoleDefinition in $RoleAssignments.RoleDefinitionBindings) {
                            if (!$RoleDefinition.Hidden) {

                                # Selct-object 新しいプロパティの取得
                                $ObjectType = @{N = "Object Type"; E = { $item.FileSystemObjectType } }
                                $path = @{N = "Path"; E = { $item.Folder.ServerRelativeUrl } }
                                $permission = @{N = "Permission"; E = { $_.Name } }
                                $role_upn = @{N = "Role UPN"; E = { $RoleAssignments.Member.LoginName } }
                                $role = @{N = "Role"; E = { $RoleAssignments.Member.Title }}
                                $type_sharepoint_group = @{N = "Type"; E = { "SharePoint Group" } } # sharepoint
                                $type_security_group = @{N = "Type"; E = { "Security Group" } } # sharepoint以外

                                switch ($RoleAssignments.Member.PrincipalType) {
                                    SharePointGroup {
                                        # MS365グループを対象にした権限付与を想定
                                        $RoleDefinition |
                                        Select-Object $ObjectType, $path, $permission, $type_sharepoint_group, $role_upn, $role
                                        Export-CSV $OutFile -Append -Force -Encoding UTF8 -NoTypeInformation
                                    }
                                    default {
                                        # byNameでの権限付与を想定
                                        $RoleDefinition |
                                        Select-Object $ObjectType , $path, $permission, $type_security_group, $role_upn, $role |
                                        Export-CSV $OutFile -Append -Force -Encoding UTF8 -NoTypeInformation
                                    }
                                }
                            }
                        }
                    }
                }

                get_SubFolders($folderUrl + "/" + $folder.Name)

            }
        }
        write-output $my_array
    }
    Catch {
        write-host -f Red "Error Generating Folder Permission Report!" $_.Exception.Message
    }
}

# Register-PnPManagementShellAccess
# Connect-PnPOnline -URL $SiteURL -Interactive

get_SubFolders($folderURL)

Function get_all_sites {
    $LibraryName = "Shared Documents"
    $folderURL = "/" + $LibraryName

    # sharepoint site urls
    $sp_sites = @(
        # e.g.
        # "https://example.com/sites/sitename"
    )

    foreach ($url in $sp_sites) {
        if ($url -match 'sites') {
            $url
            # Write-Output $url + "に接続"
            Connect-PnPOnline -ClientId $ENV:CLIENTID -CertificatePath './certificate.pfx' -CertificatePassword (ConvertTo-SecureString -AsPlainText "ops" -Force) -Url $url -Tenant "plus-medi-corp.com"
            # Get-PnPContext

            # サイトごとに出力ファイル名を変更する
            $array = $url.Split("/")
            $OutFile = "/output/" + $array[4] + ".csv" #👇get_subFolders() 出力先 ローカル
            # $OutFile="./output/" + $array[4] + ".csv" #👇get_subFolders() 出力先 VM

            get_SubFolders($folderUrl)
        }
    }
}

get_all_sites 
