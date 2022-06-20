!maine de l'aplication
program change
	! @autor Lucas Dubuc
	! ce programme doit permètre de changer de fond d'ecrant
	
	!déclaration des variables
	character(len=50) :: arg1
	character(len=50) :: arg2
	
	!on utilise la commande get_command_argument pour récupérer l'argument
	! passer en paramètre
	call get_command_argument(1, arg1)
	if (arg1 == "") then
		write(*, '(a)') "Commande invalide,"
		write(*, '(a)') "change liste => afficher la liste des fond disponible"
		write(*, '(a)') "change afficher nameImage => afficher nameImage"
		write(*, '(a)') "change image => remplacer votre fond d'ecrant par image"		
	else if (arg1 == "liste") then
		! si l'argument vaut liste on apelle le sous programe lister
		call lister()
	else if (arg1 == "afficher") then
		! si l'argument est afficher,
		! on récupère le second argument
		! puis on le passe comme paramètre de la subroutine afficher
		call get_command_argument(2, arg2)
		call afficher(arg2)
	else
		!Le cas par défaut est le changement d'ecrant
		call chagerFond(arg1)
	end if
		
end program

!Le sous programme lister donne la liste des
!fond utilisable dans fonddEcrant
subroutine lister()
	character(len=41) :: cmd
	!L'avantage de lister comme ça c'est que je n'ais pas à
	!mêtre à jours le programe si on rajoute des fond
	cmd = "dir /b C:\changeWallpaper\fondEcran\*.bmp"
	call system(cmd)
end subroutine

!Le sous programe afficher affiche l'image passer en paramètre
subroutine afficher(arg2)
	character(len=50), intent(in) :: arg2
	character(len=50) :: chemain
	character(len=100) ::  cmd
	
	chemain = "start C:\changeWallpaper\fondEcran\"
	!utiliser la fonction trim sur la première chêne de notre concatenation
	!permer de retirer tous espace indésirable
	cmd = trim(chemain) // arg2
	call system(cmd)
	
end subroutine

!sous programe de modification du fond d'ecrant
subroutine chagerFond(arg1)
	character(len=50), intent(in) :: arg1
	!on défini la taille de cette chaine en fonction de celle de l'args
	character(len=105 + len(arg1)):: cmd
	character :: reload
	integer :: i
	
	! On modifi les registre pour mêtre le chemain ver notre image
	cmd = 'reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d C:\changeWallpaper\fondEcran\'
	cmd = trim(cmd)// arg1
	write(*, '(a)') "Recuperation du chemain d'accet"
	call sleep(2) !ici la subroutine de tempo
	
	call system(cmd)
	write(*, '(a)') "Chargement de l'image"
	call sleep(2)
	cmd = "RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1 True"
	! La commande ci dessu est un programe windows obsolète depuis windows 7 mais qui reste le seule
	!moyen de changer sont fond d'ecrant en ligne de commande nous devons la répéter jusqua ce que ça marche
	
	001 do i = 1, 100 ! équivalent d'une boucle for avec une balise pour un goto
		call system("cls")
		write(*, '(a)') "loading"
		call system(cmd)
	end do
	! On tente 100 fois de lancer la commande.
	!Comme il n'y à pas de moyen de vérifier par le code si elle à marcher,
	! on demande à l'utilisateur si c'est le cas
	write(*,'(a)',advance='no') "Le fond a t'il changer?<o/n>"
	read *, reload
	if(reload == "n") then
		!si ce n'est pas le cas on retourne fait 100 tentative 
		goto 001 !L'usage des goto doit être limiter autant que possible!
		! le cas de figure ou l'on recommence une action tent qu'une codition n'est pas remplit et le seule cas tolérable
	end if
end subroutine