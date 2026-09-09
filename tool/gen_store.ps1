Add-Type -AssemblyName System.Drawing
$dir = "C:\Users\Particular\entregaveis_playstore\prints_amizade"
$W = 1080; $H = 1920

# Gradiente azul ESCURO (topo) -> azul CLARO (base), igual a logo.
$slides = @(
  @{f="01_home.png";       h1="Frases de amizade";        h2="Mais de 1.200 frases pra compartilhar"; t=@(8,20,52);  b=@(46,120,214)},
  @{f="02_categorias.png"; h1="20 categorias";            h2="Amigas, amigos, gratidão e muito mais"; t=@(10,24,58); b=@(58,138,224)},
  @{f="03_imagens.png";    h1="Fotos e fundos lindos";    h2="Imagens reais pra postar no status";     t=@(9,22,54);  b=@(40,110,206)},
  @{f="04_editor.png";     h1="Crie sua imagem";          h2="Fontes, cores e até a sua própria foto";  t=@(12,26,60); b=@(52,132,220)},
  @{f="05_lista.png";      h1="Copie e compartilhe";      h2="Um toque pro WhatsApp, Insta e Stories";   t=@(8,20,52);  b=@(48,124,216)},
  @{f="06_diaria.png";     h1="Frase do dia";             h2="Uma amizade nova todo dia por notificação"; t=@(10,24,58); b=@(44,118,210)}
)

function RoundRect($x,$y,$w,$h,$r) {
  $p = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = $r*2
  $p.AddArc($x,$y,$d,$d,180,90); $p.AddArc($x+$w-$d,$y,$d,$d,270,90)
  $p.AddArc($x+$w-$d,$y+$h-$d,$d,$d,0,90); $p.AddArc($x,$y+$h-$d,$d,$d,90,90)
  $p.CloseFigure(); return $p
}

$n = 0
foreach ($s in $slides) {
  $n++
  $shotPath = Join-Path $dir $s.f
  if (-not (Test-Path $shotPath)) { Write-Output ("PULOU (sem print): " + $s.f); continue }
  $bmp = New-Object System.Drawing.Bitmap($W,$H)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode='AntiAlias'; $g.TextRenderingHint='AntiAliasGridFit'; $g.InterpolationMode='HighQualityBicubic'
  $rect = New-Object System.Drawing.Rectangle(0,0,$W,$H)
  $c1 = [System.Drawing.Color]::FromArgb(255,$s.t[0],$s.t[1],$s.t[2])
  $c2 = [System.Drawing.Color]::FromArgb(255,$s.b[0],$s.b[1],$s.b[2])
  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,$c1,$c2,90)
  $g.FillRectangle($grad,$rect)
  # brilho suave azul-claro no topo
  $glow = New-Object System.Drawing.Drawing2D.GraphicsPath
  $glow.AddEllipse(-200,-560,$W+400,1120)
  $pgb = New-Object System.Drawing.Drawing2D.PathGradientBrush($glow)
  $pgb.CenterColor=[System.Drawing.Color]::FromArgb(70,120,190,255)
  $pgb.SurroundColors=@([System.Drawing.Color]::FromArgb(0,120,190,255))
  $g.FillPath($pgb,$glow)
  $white=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
  $shadow=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(110,0,0,0))
  $sub=New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235,214,230,255))
  $fmt=New-Object System.Drawing.StringFormat; $fmt.Alignment='Center'
  $size=66
  do { $fT=New-Object System.Drawing.Font("Segoe UI",$size,[System.Drawing.FontStyle]::Bold); $m=$g.MeasureString($s.h1,$fT); $size-=2 } while ($m.Width -gt ($W-120) -and $size -gt 30)
  $fS=New-Object System.Drawing.Font("Segoe UI Semibold",25)
  $g.DrawString($s.h1,$fT,$shadow,(New-Object System.Drawing.RectangleF(4,124,$W,130)),$fmt)
  $g.DrawString($s.h1,$fT,$white,(New-Object System.Drawing.RectangleF(0,120,$W,130)),$fmt)
  $g.DrawString($s.h2,$fS,$sub,(New-Object System.Drawing.RectangleF(0,250,$W,60)),$fmt)
  $shot=[System.Drawing.Image]::FromFile($shotPath)
  $crop=[int]($shot.Height*0.045)  # remove a barra de status (relogio/notificacoes) do topo
  $srcH=$shot.Height-$crop
  $fh=1420; $fw=[int]($fh*$shot.Width/$srcH); $fx=[int](($W-$fw)/2); $fy=360
  $g.FillPath((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,6,14,34))),(RoundRect ($fx-16) ($fy-16) ($fw+32) ($fh+32) 62))
  $g.SetClip((RoundRect $fx $fy $fw $fh 46))
  $destRect=New-Object System.Drawing.Rectangle($fx,$fy,$fw,$fh)
  $g.DrawImage($shot,$destRect,0,$crop,$shot.Width,$srcH,[System.Drawing.GraphicsUnit]::Pixel)
  $g.ResetClip(); $shot.Dispose()
  $out=Join-Path $dir ("store_{0:D2}.png" -f $n)
  $bmp.Save($out,[System.Drawing.Imaging.ImageFormat]::Png); $g.Dispose(); $bmp.Dispose()
  Write-Output ("ok " + $out)
}
Write-Output ("FIM: " + $n)
