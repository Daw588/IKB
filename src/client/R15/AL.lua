local RunService = game:GetService("RunService")

local Helper = require(script.Parent.Internal.Helper)

type ALIKType = {
	-- Config
	ExtendWhenUnreachable: boolean,
	
	-- Runtime
	_UpperTorso: BasePart,
	_UpperJoint: Motor6D,
	_LowerJoint: Motor6D,
	
	-- Constants
	_UpperJointC0Cache: CFrame,
	_LowerJointC0Cache: CFrame,
	_UpperLength: number,
	_LowerLength: number,
	_TransformResetLoop: RBXScriptConnection
}

local ALIK = {}
ALIK.__index = ALIK

function ALIK.new(character, side: "Left" | "Right", bodyType: "Arm" | "Leg")
	local self = setmetatable({} :: ALIKType, ALIK)

	local upperTorso = character.UpperTorso :: BasePart
	local upper = character[side.. "Upper".. bodyType] :: BasePart
	local lower = character[side.. "Lower".. bodyType] :: BasePart
	local tip = character[side.. if bodyType == "Arm" then "Hand" else "Foot"] :: BasePart

	local upperJoint = upper[side.. if bodyType == "Arm" then "Shoulder" else "Hip"] :: Motor6D
	local lowerJoint = lower[side.. if bodyType == "Arm" then "Elbow" else "Knee"] :: Motor6D
	local tipJoint = tip[side.. if bodyType == "Arm" then "Wrist" else "Ankle"] :: Motor6D

	local upperJointC0Cache = upperJoint.C0
	local lowerJointC0Cache = lowerJoint.C0

	local upperLength = math.abs(upperJoint.C1.Y) + math.abs(lowerJoint.C0.Y)
	local lowerLength = math.abs(lowerJoint.C1.Y) + math.abs(tipJoint.C0.Y) + math.abs(tipJoint.C1.Y)

	self._TransformResetLoop = RunService.Stepped:Connect(function()
		upperJoint.Transform = CFrame.identity
		lowerJoint.Transform = CFrame.identity
		tipJoint.Transform = CFrame.identity
	end)
	
	self.ExtendWhenUnreachable = false
	
	self._UpperTorso = upperTorso
	self._UpperJoint = upperJoint
	self._LowerJoint = lowerJoint

	self._UpperJointC0Cache = upperJointC0Cache
	self._LowerJointC0Cache = lowerJointC0Cache

	self._UpperLength = upperLength
	self._LowerLength = lowerLength

	return self
end

function ALIK:Solve(targetPosition: Vector3): ()
	local upperCFrame = self._UpperTorso.CFrame * self._UpperJointC0Cache
	local planeCF, upperAngle, lowerAngle = Helper:Solve(upperCFrame, targetPosition, self._UpperLength, self._LowerLength, self.ExtendWhenUnreachable)

	self._UpperJoint.C0 = self._UpperTorso.CFrame:ToObjectSpace(planeCF) * CFrame.Angles(upperAngle, 0, 0)
	self._LowerJoint.C0 = self._LowerJointC0Cache * CFrame.Angles(lowerAngle, 0, 0)
end

function ALIK:Destroy(): ()
	self._TransformResetLoop:Disconnect()
end

return ALIK