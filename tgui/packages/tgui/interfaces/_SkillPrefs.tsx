/* eslint-disable react/jsx-indent */
import { Box, Button } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const _SkillPrefs = (props) => {
  const { act, data } = useBackend();
  const { skills, available, per_skill } = data as any;
  return (
    <Window title="Skills" theme="dwarf" width={700} height={600}>
      <Window.Content scrollable>
        <Box style={{ 'paddingBottom': '8px' }}>
          Available skill points: {available}
        </Box>
        <ul>
          {skills.map((skill, index) => (
            <li key={index}
              style={{
                'padding': '8px',
                'marginTop': '10px',
                'display': 'flex',
                'marginBottom': '10px',
                'justifyContent': 'space-between',
                'alignItems': 'flex-start',
                'borderBottom': '1px solid gray',
              }}>
              <div
                style={{
                  'display': 'flex',
                  'flexDirection': 'column',
                  'margin': '0 12px',
                }}>
                <span style={{ 'fontSize': '1.3rem', 'fontWeight': '600' }}>
                  {skill.name}
                </span>
                <span
                  style={{
                    'margin': '8px 0',
                    'wordBreak': 'normal',
                    'maxWidth': '400px',
                    'fontWeight': '300',
                    'fontSize': ' 0.9rem',
                  }}>
                  {skill.desc}
                </span>
              </div>
              <div
                style={{
                  'display': 'flex',
                  'alignItems': 'center',
                  'margin': '0 12px',
                }}>
                <Button
                  style={{
                    'width': '24px',
                    'height': '24px',
                    'textAlign': 'center',
                  }}
                  disabled={skill.lvl < 2}
                  onClick={() => act('remove', { 'path': skill.path })}>
                  -
                </Button>
                <span style={{ 'width': '110px', 'textAlign': 'center' }}>
                  {skill.rank}
                </span>
                <Button
                  style={{
                    'width': '24px',
                    'height': '24px',
                    'textAlign': 'center',
                  }}
                  disabled={skill.lvl === per_skill + 1 || available === 0}
                  onClick={() => act('add', { 'path': skill.path })}>
                  +
                </Button>
              </div>
            </li>
          ))}
        </ul>
      </Window.Content>
    </Window>
  );
};
