Add-Type -AssemblyName System.Drawing
$out = "C:\Users\Particular\Desktop\app29\assets\icon"
New-Item -ItemType Directory -Force $out | Out-Null
$S = 1024

function GreenGrad($g,$w,$h){
  $rect = New-Object System.Drawing.Rectangle(0,0,$w,$h)
  $c1 = [System.Drawing.Color]::FromArgb(255,0x0f,0x9b,0x8e)
  $c2 = [System.Drawing.Color]::FromArgb(255,0x3e,0xf0,0x7d)
  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,$c1,$c2,45)
  $g.FillRectangle($grad,$rect)
}

# Silhueta "maos formando um coracao": coracao (curva parametrica) + 2 antebracos em V.
# Desenhada numa bitmap, escala p/ caber, e composta em branco.
function BuildGlyph([double]$scale,[double]$cx,[double]$cy){
  $bmp = New-Object System.Drawing.Bitmap($S,$S)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode='AntiAlias'
  $brush = [System.Drawing.Brushes]::White
  $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, [single](96*$scale))
  $pen.StartCap='Round'; $pen.EndCap='Round'; $pen.LineJoin='Round'

  # --- coracao parametrico ---
  $pts = New-Object System.Collections.Generic.List[System.Drawing.PointF]
  for($i=0;$i -le 60;$i++){
    $t = [math]::PI*2*$i/60
    $x = 16*[math]::Pow([math]::Sin($t),3)
    $y = 13*[math]::Cos($t) - 5*[math]::Cos(2*$t) - 2*[math]::Cos(3*$t) - [math]::Cos(4*$t)
    # escala: coracao ~ 32 largura, 30 altura -> px
    $px = $cx + $x * (14*$scale)
    $py = $cy - $y * (14*$scale) - (40*$scale)   # sobe o coracao um pouco
    $pts.Add((New-Object System.Drawing.PointF([single]$px,[single]$py)))
  }
  $hp = New-Object System.Drawing.Drawing2D.GraphicsPath
  $hp.AddClosedCurve($pts.ToArray(),0.2)

  # ponto inferior do coracao (t=PI) ~ (cx, cy - 13*... ) -> aprox base
  $baseX = $cx
  $baseY = $cy - (13*-1 -5*1 -2*-1 -1*1)*(14*$scale) - (40*$scale)  # y em t=PI
  # duas maos em concha (cradle) embaixo do coracao: 2 curvas simetricas formando tigela
  $ay = $baseY + (10*$scale)
  function Pt($x,$y){ New-Object System.Drawing.PointF([single]$x,[single]$y) }
  $left = New-Object System.Drawing.Drawing2D.GraphicsPath
  $left.AddBezier((Pt ($cx-235*$scale) ($ay+10*$scale)), (Pt ($cx-235*$scale) ($ay+205*$scale)), (Pt ($cx-70*$scale) ($ay+215*$scale)), (Pt ($cx-16*$scale) ($ay+150*$scale)))
  $right = New-Object System.Drawing.Drawing2D.GraphicsPath
  $right.AddBezier((Pt ($cx+235*$scale) ($ay+10*$scale)), (Pt ($cx+235*$scale) ($ay+205*$scale)), (Pt ($cx+70*$scale) ($ay+215*$scale)), (Pt ($cx+16*$scale) ($ay+150*$scale)))
  $g.DrawPath($pen,$left)
  $g.DrawPath($pen,$right)
  # preenche o coracao por cima das juntas
  $g.FillPath($brush,$hp)
  $g.Dispose()
  return $bmp
}

function Compose($withBg,$scale,$file){
  $b = New-Object System.Drawing.Bitmap($S,$S)
  $g = [System.Drawing.Graphics]::FromImage($b)
  $g.SmoothingMode='AntiAlias'; $g.InterpolationMode='HighQualityBicubic'
  if($withBg){ GreenGrad $g $S $S }
  $glyph = BuildGlyph $scale ($S/2) ($S/2)
  # sombra leve
  if($withBg){
    $g.DrawImage($glyph,6,8)
  }
  $g.DrawImage($glyph,0,0)
  $glyph.Dispose()
  $b.Save("$out\$file",[System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $b.Dispose()
}

Compose $true  1.0 "icon.png"       # legado full-bleed
# bg so gradiente
$b2=New-Object System.Drawing.Bitmap($S,$S); $g2=[System.Drawing.Graphics]::FromImage($b2); GreenGrad $g2 $S $S; $b2.Save("$out\bg.png",[System.Drawing.Imaging.ImageFormat]::Png); $g2.Dispose(); $b2.Dispose()
Compose $false 0.82 "icon_fg.png"   # adaptive fg (menor p/ safe zone)
Write-Output "icons gerados"
