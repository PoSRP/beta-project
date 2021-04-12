
TYPE
	ctrlStateEnum : 
		(
		CTRL_INIT,
		CTRL_OFF,
		CTRL_POWER_ON_AXIS,
		CTRL_POWERING_ON_AXIS,
		CTRL_POWER_OFF_AXIS,
		CTRL_POWERING_OFF_AXIS,
		CTRL_HOME_AXIS,
		CTRL_HOMING_AXIS,
		CTRL_STOPPING,
		CTRL_STANDSTILL,
		CTRL_MOVE_VELOCITY,
		CTRL_MOVE_ABSOLUTE,
		CTRL_ERROR,
		CTRL_MOVE_VELOCITY_ERROR,
		CTRL_MOVE_ABSOLUTE_ERROR,
		CTRL_FATAL_ERROR,
		CTRL_FATAL_ERROR_EXIT
	);
	mcBlocksType : STRUCT
		power : MC_Power;
		home : MC_Home;
		stop : MC_Stop;
		reset : MC_Reset;
		moveVelocity : MC_MoveVelocity;
		moveAbsolute : MC_MoveAbsolute;
		currentPosition : MC_ReadActualPosition;
		currentVelocity : MC_ReadActualVelocity;
		status : MC_ReadStatus;
		error : MC_ReadAxisError;
	END_STRUCT;
	
END_TYPE
