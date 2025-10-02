// ? Added that cause its unfunny joke, eslint is telling one, react/retard otherwise
/* eslint-disable react/jsx-indent */
import {
  Button,
  Tabs,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

export const _BuilderHammer = (props) => {
  const { act, data } = useBackend();
  const { blueprints, activeBlueprint } = data as any;
  const [tabIndex, setTabIndex] = useLocalState('tabIndex', 0);
  const [bpIndex, setBpIndex] = useLocalState('bpIndex', -1);
  const [previewOrientation, setPreviewOrientation] = useLocalState('previewOrientation', 0);
  const activeBlueprintObject = blueprints[tabIndex].blueprints[bpIndex];
  return (
    <Window title="Building Menu" theme="dwarf" width={756} height={600}>
      <Window.Content>
        <div
          style={{
            height: '100%',
            width: '100%',
            display: 'flex',
          }}>
          <div style={{ flex: '1 1', marginRight: '6px' }}>
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                height: '100%',
              }}>
              <div
                style={{
                  marginBottom: '6px',
                }}>
                <Tabs>
                  {blueprints.map((cat, i) => (
                    <Tabs.Tab
                      selected={i === tabIndex}
                      key={cat}
                      onClick={() => {
                        setBpIndex(0);
                        setTabIndex(i);
                      }}>
                      {capitalize(cat.name)}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              </div>
              <div
                style={{
                  backgroundColor: 'rgba(0,0,0,0.3)',
                  height: '100%',
                  padding: '6px',
                }}>
                <div style={{ display: 'flex', flexWrap: 'wrap' }}>
                  {blueprints[tabIndex].blueprints.map((bp, i) => (
                    <div
                      key={bp.name}
                      style={{
                        border: `3px solid ${
                          i === bpIndex ? 'gray' : 'transparent'
                        }`,
                      }}>
                      <Button
                        width="80px"
                        height="80px"
                        m="4px"
                        style={{
                          padding: '0',
                        }}
                        onClick={() => setBpIndex(i)}>
                        <div
                          style={{
                            position: 'relative',
                            height: '100%',
                            width: '100%',
                            display: 'flex',
                            flexDirection: 'column',
                            alignItems: 'center',
                          }}>
                          <div
                            style={{
                              height: '100%',
                              width: '100%',
                              display: 'flex',
                              alignItems: 'center',
                              justifyContent: 'center',
                              padding: '6px',
                            }}>
                            <div
                              style={{
                                height: '50px',
                                width: '50px',
                                backgroundImage: 'url(' + bp.icon + ')',
                                backgroundSize: 'contain',
                                backgroundRepeat: 'no-repeat',
                                backgroundPosition: 'center',
                              }}
                            />
                          </div>
                          <div
                            style={{
                              display: 'flex',
                              position: 'relative',
                              maxWidth: '80px',
                              top: '-5px',
                            }}>
                            <span
                              style={{
                                position: 'relative',
                                textAlign: 'center',
                                whiteSpace: 'normal',
                                display: 'inline-block',
                                maxWidth: '80px',
                                wordWrap: 'break-word',
                              }}>
                              {capitalize(bp.name)}
                            </span>
                          </div>
                        </div>
                      </Button>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          </div>
          <div
            style={{
              width: '256px',
              minWidth: '256px',
              height: '100%',
              backgroundColor: 'rgba(0,0,0,0.3)',
            }}>
            {bpIndex > -1 && (
              <div
                style={{
                  margin: '0',
                  height: '100%',
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  padding: '8px',
                }}>
                <h1 style={{ fontSize: '2.2rem' }}>
                  {capitalize(activeBlueprintObject.name)}
                </h1>
                <div
                  style={{
                    margin: '8px 0',
                    width: '128px',
                    height: '128px',
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'center',
                  }}>
                  <img
                    style={{
                      height: previewOrientation === 0 ? 'auto' : '100%',
                      width: previewOrientation === 0 ? '100%' : 'auto',
                      display: 'block',
                      // msInterpolationMode: 'nearest-neighbor',
                      imageRendering: 'pixelated',
                    }}
                    src={activeBlueprintObject.icon}
                    onLoad={(e) =>
                      setPreviewOrientation(
                        e.currentTarget.naturalWidth > e.currentTarget.naturalHeight ? 0 : 1
                      )}
                  />
                </div>
                <hr
                  style={{
                    'width': '75%',
                    'borderTop': '0',
                    'borderColor': 'gray',
                  }}
                />
                <div
                  style={{
                    'width': '100%',
                    'textAlign': 'center',
                    'margin': '8px 0',
                  }}>
                  {capitalize(activeBlueprintObject.desc)}
                </div>
                <hr
                  style={{
                    'width': '75%',
                    'borderTop': '0',
                    'borderColor': 'gray',
                  }}
                />
                <h2>Resources</h2>
                <div
                  style={{
                    'flexGrow': '1',
                    'width': '100%',
                  }}>
                  <div
                    style={{
                      'display': 'flex',
                      'flexDirection': 'column',
                    }}>
                    {activeBlueprintObject.reqs.map((req) => (
                      <div
                        key={req}
                        style={{ 'display': 'flex', 'alignItems': 'center' }}>
                        <img
                          style={{
                            // 'ms-interpolation-mode': 'nearest-neighbor',
                            'imageRendering': 'pixelated',
                          }}
                          src={req.icon}
                        />
                        <span style={{ 'marginRight': '16px' }}>
                          {capitalize(req.name)}
                        </span>
                        <hr
                          style={{
                            'width': '75%',
                            'borderTop': '0',
                            'borderColor': 'gray',
                            'marginTop': '9px',
                          }}
                        />
                        <span
                          style={{
                            'marginLeft': '16px',
                          }}>
                          {`x${req.amount}`}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
                <hr
                  style={{
                    'width': '75%',
                    'borderTop': '0',
                    'borderColor': 'gray',
                  }}
                />
                <Button
                  style={{
                    'marginTop': '8px',
                    'height': '40px',
                    'width': '128px',
                    'verticalAlign': 'center',
                  }}
                  onClick={() =>
                    act('select_blueprint', {
                      path: activeBlueprintObject.path,
                    })}>
                  <div
                    style={{
                      'height': '40px',
                      'display': 'flex',
                      'alignItems': 'center',
                      'justifyContent': 'center',
                      'paddingBottom': '4px',
                    }}>
                    <span
                      style={{ 'fontWeight': '600', 'fontSize': '1.2rem' }}>
                      CONFIRM
                    </span>
                  </div>
                </Button>
              </div>
            )}
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
