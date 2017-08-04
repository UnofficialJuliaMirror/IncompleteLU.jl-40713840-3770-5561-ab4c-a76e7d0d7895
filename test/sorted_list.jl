import ILU: SortedIndices, init!, push!
using Base.Test

@testset "Sorted indices" begin
    @testset "New values" begin
        indices = SortedIndices(10)
        init!(indices, 3)
        @test push!(indices, 5)
        @test push!(indices, 7)
        @test push!(indices, 4)
        @test push!(indices, 6)
        @test push!(indices, 8)

        as_vec = convert(Vector, indices)
        @test as_vec == [3, 4, 5, 6, 7, 8]
    end

    @testset "Duplicate values" begin
        indices = SortedIndices(10)
        init!(indices, 3)
        @test push!(indices, 3) == false
        @test push!(indices, 8)
        @test push!(indices, 8) == false
    end

    @testset "Quick insertion with known previous index" begin
        indices = SortedIndices(10)
        init!(indices, 3)
        @test push!(indices, 4, 3)
        @test push!(indices, 8, 4)
        @test convert(Vector, indices) == [3, 4, 8]
    end
end