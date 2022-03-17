def rolling_mean(data, varname) :

	"""
	Compute rolling mean for a whole year
	
	IN:
	data : [xarray.Dataset]
	varname : [str] 
	
	OUT:
	[DataArray]
	"""
	import xarray as xr
	
	try :
		assert isinstance(data, xr.Dataset)
		
	except AssertionError :
		print(f'Expected Dataset, got {tyoe(data)}. Use .to_dataset() to convert DataArray into DataSet')
		
	return eval(f"xr.concat([data.roll(dayofyear=150, roll_coords= True).{varname}.rolling(dayofyear=30, center=True).mean().roll(dayofyear=-150, roll_coords= True)[:15],data.{varname}.rolling(dayofyear=30, center=True).mean().dropna('dayofyear'),data.roll(dayofyear=150, roll_coords= True).{varname}.rolling(dayofyear=30, center=True).mean().roll(dayofyear=-150, roll_coords= True)[-14:]],dim = 'dayofyear')")
