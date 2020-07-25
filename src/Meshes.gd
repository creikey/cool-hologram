extends Spatial

func _process(delta):
	$InnerArrows.rotation.y += delta/3.0
	$DashedLine.rotation.y -= delta/10.0
	$OuterDashes.rotation.y += delta/15.0
#	$OrbitPivotPoint.rotation.x += delta/7.0
#	$OrbitPivotPoint.rotation.y += delta/12.0
	$OrbitPivotPoint.rotation.z += delta/2.0
	$OrbitPivotPoint/OrbitingPlanet.rotation.x += delta/6.0
	$OrbitPivotPoint/OrbitingPlanet.rotation.z += delta/8.0
