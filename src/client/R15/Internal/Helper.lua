--!strict

local VECTOR3_NEGATIVE_ZAXIS = Vector3.zAxis * -1

local MATH_HALF_PI = math.pi / 2
local MATH_NEGATIVE_HALF_PI = -MATH_HALF_PI

local Helper = {}

function Helper:Solve(originCF: CFrame, targetPos: Vector3, l1: number, l2: number, extendWhenUnreachable: boolean): (CFrame, number, number)
	-- Build intial values for solving
	local localized = originCF:PointToObjectSpace(targetPos)
	local l3 = localized.Magnitude

	-- Build a "rolled" planeCF for a more natural arm look
	local planeCF = originCF * CFrame.fromAxisAngle(
		VECTOR3_NEGATIVE_ZAXIS:Cross(localized.Unit), -- Axis
		math.acos(-localized.Unit.Z) -- Angle
	)

	--[[
		Case: point is to close, unreachable
		Return: push back planeCF so the "hand" still reaches, angles fully compressed
	]]
	local maxMinusMin = math.max(l2, l1) - math.min(l2, l1)
	if l3 < maxMinusMin then
		return planeCF * CFrame.new(Vector3.zAxis * (maxMinusMin - l3)), MATH_NEGATIVE_HALF_PI, math.pi
	end
	
	--[[
		Case: point is to far, unreachable
		Return: for forward planeCF so the "hand" still reaches, angles fully extended
	]]
	local added = l1 + l2
	if l3 > added then
		return if extendWhenUnreachable then planeCF * CFrame.new(Vector3.zAxis * (added - l3)) else planeCF, MATH_HALF_PI, 0
	end
	
	--[[
		Case: point is reachable
		Return: planeCF is fine, solve the angles of the triangle
	]]
	local a1 = -math.acos((-(l2 * l2) + (l1 * l1) + (l3 * l3)) / (2 * l1 * l3))
	return planeCF, a1 + MATH_HALF_PI, math.acos(((l2 * l2) - (l1 * l1) + (l3 * l3)) / (2 * l2 * l3)) - a1
end

return Helper