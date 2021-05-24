TYPE
	controlStateEnum : (
		CTRL_INIT,
		CTRL_HOME_START,
		CTRL_HOME_SEEK_NEG,
		CTRL_HOME_SEEK_POS,
		CTRL_HOME_CENTER,
		CTRL_STOP,
		CTRL_RUNNING,
		CTRL_NO_SIM,
		CTRL_NO_CONTROLLER
	);
	
	opcuaType : STRUCT 			(* For OPCUA *)
		cartPosition : REAL := 0.0;		(* mm *)
		cartVelocity : REAL := 0.0;		(* mm/s *)
		pendulumAngle : REAL := 0.0;	(* Rad, 0 is upright position *)
		setCartVelocity : REAL := 0.0;	(* Negative is backward motion *)
	END_STRUCT;

	pviMotorType : STRUCT
		start : BOOL := FALSE;				(* Start the motor *)
		forward : BOOL := FALSE;			(* Set motor direction *)
		setVelocity : INT := 0;				(*  *)
		setConverterFrequency : INT := 0;	(*  *)
		isStarted : BOOL := FALSE;			(*  *)
		isStopped : BOOL := FALSE;			(*  *)
		isForward : BOOL := FALSE;			(*  *)
		isBackward : BOOL := FALSE;			(*  *)
		isMax : BOOL := FALSE;				(* Motor is at max limit *)
		isMiddle : BOOL := FALSE;			(* Motor is on exact middle *)
		isMin : BOOL := FALSE;				(* Motor is at min limit *)
		offsetMax : BOOL := FALSE;			(*  *)
		offsetMin : BOOL := FALSE;			(*  *)
		isReset : BOOL := FALSE;			(*  *)
		velocity : INT := 0;				(* Actual motor velocity *)
	END_STRUCT;
	
	pviType : STRUCT
		cartPositionEncoder : DINT := 0;	(* Cart position encoder output, currently in 1mm/units *)
		pendulumAngle : DINT := 0; 		(* Angle output, 1024 divisions per rotation *)
		motor : pviMotorType;			(* All motor specific variables *)
	END_STRUCT;
	
	controlType : STRUCT
		state : controlStateEnum;		(*  *)
		setVelocity : REAL;				(*  *)
		setPosition : REAL := 0;
		setPointPosition : REAL := 0;
		setAngle : REAL := 0;
		currentPosition : REAL;			(*  *)
		currentAngle : REAL;			(*  *)
		currentVelocity : REAL;			(*  *)
		currentAngularVelocity : REAL;
		currentDirection : BOOL;		(*  *)
		limitAcceleration : REAL := 1000;	(*  *)
		limitVelocity : REAL := 200;	(*  *)
		limitPosPos : DINT := -5000;	(*  *)
		limitNegPos : DINT := 5000;		(*  *)
		homing : homingType;		(*  *)
	END_STRUCT;
	
	localLqrType : STRUCT
		A : ARRAY[1..4, 1..4] OF LREAL := 0, 0, 0, 0, 1, -10, 0, -55.8140, 0, 1.6498, 0, 64.0173, 0, -0.00134, 1, -0.5198;
		B : ARRAY[1..4] OF LREAL := 0, 2, 0, 11.1628;
		C : ARRAY[1..4, 1..2] OF LREAL := 1, 0, 0, 0, 0, 1, 0, 0;	
		Kf : ARRAY[1..2, 1..4] OF LREAL := -1.0074, -0.0185, -0.1490, -1.0585, -0.1490, -1.3128, -14.9055, -110.5974;
		Klqr : ARRAY[1..4] OF LREAL := -3.3541, -12.8984, 57.1684, 16.7280;
		
		x : ARRAY[1..4] OF LREAL := 0,0,0,0;
		xPre : ARRAY[1..4] OF LREAL := 0,0,0,0;
		xn : ARRAY[1..4] OF LREAL := 0,0,0,0;
		xn1 : ARRAY[1..4] OF LREAL := 0,0,0,0;
		est : ARRAY[1..4] OF LREAL := 0,0,0,0;
		
		temp : LREAL;
		Ts : LREAL := 0.01;
	END_STRUCT;
	
	homingType : STRUCT
		foundNegLim : REAL;				(*  *)
		foundPosLim : REAL;				(*  *)
		seekVelocity : REAL := 500;		(*  *)
		middleVelocity : REAL := 1500;	(*  *)
	END_STRUCT;
	
	hmiType : STRUCT
		fields : hmiFieldType;			(*  *)
		indicators : hmiIndicatorType;	(*  *)
		buttons : hmiButtonType;			(*  *)

	END_STRUCT;	
	
	hmiButtonType : STRUCT
		start : BOOL;					(*  *)
		startPrevious : BOOL;
		localPid : BOOL;				(*  *)
		localPidPrevious : BOOL;
		simulinkPid : BOOL;				(*  *)
		simulinkPidPrevious : BOOL;
		experiorSim : BOOL;				(*  *)
		experiorSimPrevious : BOOL;
		simulinkSim : BOOL;				(*  *)
		simulinkSimPrevious : BOOL;
	END_STRUCT;

	hmiFieldType : STRUCT
		velocity : REAL;			(*  *)
		position : REAL;			(*  *)
		angle : REAL;				(*  *)
		ovrPosition : REAL;			(*  *)
		accelerationLimit : REAL;		(*  *)
		velocityLimit : REAL;			(*  *)
		positionLimitNeg : REAL;		(*  *)
		positionLimitPos : REAL;		(*  *)
		controlState : WSTRING[40];		(*  *)
	END_STRUCT;

	hmiIndicatorType : STRUCT
		pvi : BOOL; 	(*  *)
		opcua : BOOL;	(*  *)
	END_STRUCT;
	
END_TYPE