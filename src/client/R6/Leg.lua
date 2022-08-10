local RunService = game:GetService("RunService")

local LEFT_HIP_CFRAME = CFrame.new(-0.5, -1, 0)
local RIGHT_HIP_CFRAME = CFrame.new(0.5, -1, 0)

local CFRAME_ANGLES_PI = CFrame.Angles(0, math.pi, 0)

type IKLegType = {
	-- Runtime
	_Torso: BasePart,
	_Hip: Motor6D,
	
	-- Constants
	_HipC0Cache: CFrame,
	_TransformResetLoop: RBXScriptConnection
}

local IKLeg = {}
IKLeg.__index = IKLeg

function IKLeg.new(character, side: "Left" | "Right")
	local self = setmetatable({} :: IKLegType, IKLeg)
	
	local torso = character.Torso :: BasePart
	local hip = torso[side.. " Hip"] :: Motor6D
	
	--[[
		Keep resetting transform; why?
		because otherwise the arms will be going crazy!
	]]
	self._TransformResetLoop = RunService.Stepped:Connect(function()
		-- CFrame.identity is basically CFrame.new() but constant; therefore faster!
		hip.Transform = CFrame.identity
	end)
	
	self._Torso = torso
	self._Hip = hip
	
	self._HipC0Cache = if side == "Left" then LEFT_HIP_CFRAME else RIGHT_HIP_CFRAME
	
	return self
end

function IKLeg:Solve(targetPosition: Vector3): ()
	local offset = (self._Torso.CFrame * self._HipC0Cache):PointToObjectSpace(targetPosition)
	local x, y = math.atan2(offset.Z, offset.Y), math.atan2(offset.X, offset.Y)
	self._Hip.C0 = self._HipC0Cache * CFrame.Angles(x, 0, y) * CFRAME_ANGLES_PI
end

function IKLeg:Destroy(): ()
	self._TransformResetLoop:Disconnect()
end

return IKLeg