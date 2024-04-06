##Frahati AHAMADI
##24/03/2024
##Version 2


# Fonction pour créer une étendue DHCP avec plage d'adresses
function CreerEtendueDHCP {
    param(
        [string]$NomEtendue,
        [string]$AdresseReseau,
        [string]$Masque,
        [string]$PremiereAdresse,
        [string]$DerniereAdresse,
        [string]$Passerelle,
        [string]$NomDomaine,
        [string]$AdresseIPServeurDomaine
    )

    # Afficher les informations de l'étendue DHCP
    Write-Host "Nom de l'étendue DHCP : $NomEtendue"
    Write-Host "Adresse réseau : $AdresseReseau"
    Write-Host "Masque : $Masque"
    Write-Host "Première adresse à distribuer : $PremiereAdresse"
    Write-Host "Dernière adresse à distribuer : $DerniereAdresse"
    Write-Host "Passerelle par défaut : $Passerelle"
    Write-Host "Nom de domaine : $NomDomaine"
    Write-Host "Adresse IP du serveur de domaine : $AdresseIPServeurDomaine"

    # Demander à l'utilisateur s'il souhaite créer l'étendue DHCP
    $Confirmation = Read-Host "Voulez-vous créer cette étendue DHCP ? (O/N)"

    if ($Confirmation -eq "O" -or $Confirmation -eq "o") {
        # Création de l'étendue DHCP
        Add-DhcpServerv4Scope -Name $NomEtendue -StartRange $PremiereAdresse -EndRange $DerniereAdresse `
            -SubnetMask $Masque -State Active -Description "Créée via script PowerShell"
        
        # Définir la passerelle par défaut
        Set-DhcpServerv4OptionValue -ScopeID $NomEtendue -Router $Passerelle

        # Définir le nom de domaine et l'adresse IP du serveur de domaine
        Set-DhcpServerv4OptionValue -OptionId 6 -Value"$NomDomaine" -ScopeId $AdresseReseau
        Set-DhcpServerv4OptionValue -ScopeID $NomEtendue -DnsServer $AdresseIPServeurDomaine

        # Définir le nom de domaine pour l'étendue DHCP
        Set-DhcpServerv4OptionValue -OptionId 15 -Value "$nomDomaine" -ScopeId $AdresseReseau
        Set-DhcpServerv4OptionValue -OptionId 44 -Value "$AdresseIPServeurDomaine" -ScopeId $AdresseReseau
        
        Write-Host "L'étendue DHCP a été créée avec succès."
    }
    else {
        Write-Host "Opération annulée. L'étendue DHCP n'a pas été créée."
    }
}

# Demander à l'utilisateur les informations pour créer l'étendue DHCP
$NomEtendue = Read-Host "Entrez le nom de l'étendue DHCP"
$AdresseReseau = Read-Host "Entrez l'adresse réseau de l'étendue DHCP"
$Masque = Read-Host "Entrez le masque de sous-réseau de l'étendue DHCP"
$PremiereAdresse = Read-Host "Entrez la première adresse à distribuer dans l'étendue DHCP"
$DerniereAdresse = Read-Host "Entrez la dernière adresse à distribuer dans l'étendue DHCP"
$Passerelle = Read-Host "Entrez l'adresse de la passerelle par défaut"
$NomDomaine = Read-Host "Entrez le nom du domaine"
$AdresseIPServeurDomaine = Read-Host "Entrez l'adresse IP du serveur de domaine"

# Appeler la fonction pour créer l'étendue DHCP avec les informations fournies
CreerEtendueDHCP -NomEtendue $NomEtendue -AdresseReseau $AdresseReseau -Masque $Masque `
    -PremiereAdresse $PremiereAdresse -DerniereAdresse $DerniereAdresse -Passerelle $Passerelle `
    -NomDomaine $NomDomaine -AdresseIPServeurDomaine $AdresseIPServeurDomaine
