
testopencl = TestOpenCL();
testopenmp = TestOpenMP();
testpthreads = TestPthreads();
testcuda = TestCUDA();
testserial = TestSerial();

immutable TestBackend
    flag::Int64;
    function TestBackend(n::Int64)
        @assert n>=1 && n<=5;
        return new(n);
    end
end

const test_opencl  =TestBackend(1);
const test_openmp  =TestBackend(2);
const test_pthreads=TestBackend(3);
const test_cuda    =TestBackend(4);
const test_serial  =TestBackend(5);


function (==)(rhs::TestBackend,lhs::TestBackend)
    return (rhs.flag==lhs.flag);
end



function get_info_string(backend::TestBackend)
    OpenMP_Info   = "mode = OpenMP  , schedule = compact, chunk = 10";
    OpenCL_Info   = "mode = OpenCL  , platformID = 0, deviceID = 0";
    CUDA_Info     = "mode = CUDA    , deviceID = 0";
    Pthreads_Info = "mode = Pthreads, threadCount = 4, schedule = compact, pinnedCores = [0, 0, 1, 1]";
    #COI_Info      = "mode = COI     , deviceID = 0";

    linfo::String = "";
    if backend == TestBackend(testopencl)
        if OCCA.USE_OPENCL
            linfo=OpenCL_Info;
        else
            print("OpenCL support not compiled in OCCA.\n");
            return OpenMP_Info;
        end
    end
    if backend == TestBackend(testopenmp)
        if OCCA.USE_OPENMP
            linfo=OpenMP_Info;
        else
            print("OpenMP support not compiled in OCCA.\n");
            return OpenMP_Info;
        end
    end
    if backend==TestBackend(testcuda)
        if OCCA.USE_CUDA
            linfo = CUDA_Info;
        else
            print("CUDA support not compiled in OCCA.\n");
            return OpenMP_Info;
        end
    end
    if backend==TestBackend(testpthreads)
        if OCCA.USE_PTHREADS
            linfo = Pthreads_Info;
        else
            print("Pthreads support not compiled in OCCA.\n");
            return OpenMP_Info;
        end
    end

    #OpenMP will default to serial implementation if it is not otherwise built into OCCA.
    if backend==TestBackend(testserial)
        linfo = OpenMP_Info;
    end




    return linfo;
end
