float get_random_0_1_ul(unsigned int* seed)
{
  *seed = ((*seed) * 16807 ) % 2147483647;
  return  (float)(*seed) * 4.6566129e-10; //(4.6566129e-10 = 1/(2^31-1) = 1/2147483647)
}

__kernel void clinit(float4 cursor, __global float4 *lpos, __global float4 *lcol, __global float4 *lvel)
{
    int global_id = get_global_id(0);
    unsigned int tmp = get_num_groups(0);
    unsigned int seed = (unsigned int)global_id + (unsigned int)(get_random_0_1_ul(&tmp) * 10000000);
    float4 pos = lpos[global_id];
    float4 vel = lvel[global_id];
    float4 col = lcol[global_id];

    float r = (float)get_random_0_1_ul(&seed)*(75.0f);
    float phi = (float)(get_random_0_1_ul(&seed)*M_PI);
    float theta = (float)(get_random_0_1_ul(&seed)*M_PI*2.0f);
    pos.x = (float)(r * cos(theta) * sin(phi));
    pos.y = (float)(r * sin(theta) * sin(phi));
    //pos.z = (float)(r * cos(phi));
    pos.z = 0.0f;
    pos.w = 0.0f;
    col.x = 1.0f;
    col.y = 0.0f;
    col.z = 0.0f;
    col.w = 0.0f;
    vel.x = 0.0f;
    vel.y = 0.0f;
    vel.z = 0.0f;
    vel.w = 0.0f;
    lpos[global_id] = pos;
    lcol[global_id] = col;
    lvel[global_id] = vel;
}

__kernel void clpart(float4 cursor, __global float4 *lpos, __global float4 *lcol, __global float4 *lvel)
{
    int global_id = get_global_id(0);
    float4 pos = lpos[global_id];
    float4 vel = lvel[global_id];
    float4 col = lcol[global_id];

    if (cursor.x != -1.0f && cursor.y != -1.0f)
    {
        float m = 10000.0f;
        float dt = 0.8f;
        pos.z = 0.0f;
        pos.w = 0.0f;
        cursor.z = 0.0f;
        float4 force = cursor - pos;
        float dist = sqrt(force.x * force.x + force.y * force.y);
        float G = 0.00000000006667;
        float acc = G*(1.0f*m)/(dist*dist*dist);
        //float acc = (10.0f*m)/(dist*dist*dist);
        //float4 a = acc * force;
        //if (acc > 0.001f)
        //{
             //printf("%f", acc);
         //    acc = 0.001f;
        //}
        float4 a = acc * force;

    /*
        float dt = 1.0f;
        float4 force = cursor - pos;
        float distance = sqrt(force.x * force.x + force.y * force.y);
        //if (distance < 0.1f)
          //  distance = 0.1f;
        float4 acc;
        acc.x = 10 * force.x / pow(distance, 3);
        acc.y = 10 * force.y / pow(distance, 3);
        acc.z = 0.0f;
        acc.w = 0.0f;
        vel += acc * dt; */




        float2 postest;
        postest.x = pos.x;
        postest.y = pos.y;
        float2 curtest;
        curtest.x = cursor.x;
        curtest.y = cursor.y;
        col.x = 1.0f / (dist / 1280.0f);
       // col.x = 1.0f;
        col.y = 0.0f;
        col.z = 0.0f;

        a = normalize(a);
        vel += a * dt;
        pos += vel * dt;
        //vel = (vel + acc * force) * dt;
        //pos = pos + (vel * dt);
        //pos = pos + (vel * dt);

        pos.z = 0.0f;
        lpos[global_id] = pos;
        lcol[global_id] = col;
        lvel[global_id] = vel;
    }
}